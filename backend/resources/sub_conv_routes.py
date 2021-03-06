#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import SubConvertor, SubConvertorSchema, sub_convertor_schema, sub_convertors_schema, db, ma

from sqlalchemy import or_


sub_convblue = Blueprint("sub_convblue", __name__)

# GET All SubConvertor
@sub_convblue.route('/subconvertor', methods=['GET'])
def get_sub_convs():
    all_sub_conv = SubConvertor.query.all()
    result = sub_convertors_schema.dump(all_sub_conv)
    return jsonify(result)

# GET Single SubConvertor
@sub_convblue.route('/subconvertor/<Sub_code>', methods=['GET'])
def get_sub_conv(Sub_code):
    sub_conv_detail = SubConvertor.query.get(Sub_code)
    result = sub_convertor_schema.dump(sub_conv_detail)
    return jsonify(result)

#Create a SubConvertor Row
@sub_convblue.route('/subconvertor', methods=['POST'])
def add_sub_conv():
    Sub_code = request.json['Sub_code']
    Subject = request.json['Subject']

    new_sub_conv = SubConvertor(Sub_code, Subject)

    db.session.add(new_sub_conv)
    db.session.commit()

    # returns the created json 
    return sub_convertor_schema.jsonify(new_sub_conv)


# Update a SubConvertor Row
@sub_convblue.route('/subconvertor/<Sub_code>', methods=['PUT'])
def update_sub_conv(Sub_code):
    sub_conv_detail = SubConvertor.query.get(Sub_code)

    if not sub_conv_detail :
        # subject doesnt exists 
        return jsonify({'code': 408})

    Sub_code = request.json['Sub_code']
    Subject = request.json['Subject']

    sub_conv_detail.Sub_code = Sub_code
    sub_conv_detail.Subject = Subject

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Delete SubConvertor
@sub_convblue.route('/subconvertor/<Sub_code>', methods=['DELETE'])
def delete_sub_conv(Sub_code):
    sub_conv_detail = SubConvertor.query.get(Sub_code)

    if not sub_conv_detail :
        # subject doesnt exist
        return jsonify({'code':408})
        
    db.session.delete(sub_conv_detail)
    db.session.commit()
    return jsonify({'code':200})














