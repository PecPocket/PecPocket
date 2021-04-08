#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import super_schema, supers_schema, Super, SuperSchema
from database.extensions import db, ma

superblue = Blueprint("superblue", __name__)

#Create a Super Row
@superblue.route('/super', methods=['POST'])
def add_super():
    SID = request.json['SID']
    Name = request.json['Name']
    Email = request.json['Email']

    new_super = Super(SID, Name, Email)

    db.session.add(new_super)
    db.session.commit()

    # returns the created json 
    return super_schema.jsonify(new_super)

# GET All Super
@superblue.route('/super', methods=['GET'])
def get_supers():
    all_supers = Super.query.all()
    result = supers_schema.dump(all_supers)
    return jsonify(result)

# GET Single Super
@superblue.route('/super/<SID>', methods=['GET'])
def get_super(SID):
    single_super = Super.query.get(SID)
    result = super_schema.dump(single_super)
    return jsonify(result)

# Update a Super Row
@superblue.route('/super/<SID>', methods=['PUT'])
def update_super(SID):
    single_super = Super.query.get(SID)

    SID = request.json['SID']
    Name = request.json['Name']
    Email = request.json['Email']

    single_super.SID = SID
    single_super.Name = Name
    single_super.Email = Email 

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})

# Delete Super
@superblue.route('/super/<SID>', methods=['DELETE'])
def delete_super(SID):
    single_super = Super.query.get(SID)
    db.session.delete(single_super)
    db.session.commit()
    return jsonify({'code':200})