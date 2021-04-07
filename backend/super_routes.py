# pylint: disable=no-member
from flask import Flask, request, jsonify
#from main_backend import db
#from flask_marshmallow import Marshmallow
from main_backend import Super, SuperSchema, db
from __main__ import app

# # Init Marshmallow
# ma = Marshmallow(app)

# # Super Table
# class Super(db.Model):
#     SID = db.Column(db.Integer, primary_key = True)
#     Name = db.Column(db.String(100),nullable=False )
#     Email = db.Column(db.String(100),nullable=False )

#     def __init__(self, SID, Name, Email):
#         self.Name = Name
#         self.SID = SID
#         self.Email = Email
    
# class SuperSchema(ma.Schema):
#     class Meta:
#         fields = ("SID", "Name", "Email")


# Init Schema
super_schema = SuperSchema()
supers_schema = SuperSchema(many=True)


#Create a Super Row
@app.route('/super', methods=['POST'])
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
@app.route('/super', methods=['GET'])
def get_supers():
    all_supers = Super.query.all()
    result = supers_schema.dump(all_supers)
    return jsonify(result)

# GET Single Super
@app.route('/super/<SID>', methods=['GET'])
def get_super(SID):
    single_super = Super.query.get(SID)
    result = super_schema.dump(single_super)
    return jsonify(result)

# Update a Super Row
@app.route('/super/<SID>', methods=['PUT'])
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
@app.route('/super/<SID>', methods=['DELETE'])
def delete_super(SID):
    single_super = Super.query.get(SID)
    db.session.delete(single_super)
    db.session.commit()
    return jsonify({'code':200})


# Run server
if __name__ == '__main__':
    app.run(debug=True)

