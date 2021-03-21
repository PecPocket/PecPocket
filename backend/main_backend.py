
# pylint: disable=no-member

from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_marshmallow import Marshmallow
import os

# Init app
app = Flask(__name__)
basedir = os.path.abspath(os.path.dirname(__file__))

# Database
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///' + os.path.join(basedir, 'database/db.sqlite')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Init Database
db = SQLAlchemy(app)

# Init Marshmallow
ma = Marshmallow(app)

# Super Table
class Super(db.Model):
    SID = db.Column(db.Integer, primary_key = True)
    name = db.Column(db.String(100), )
    email = db.Column(db.String(100), )

    def __init__(self, SID, name, email):
        self.name = name
        self.SID = SID
        self.email = email
    
# Super Schema
class SuperSchema(ma.Schema):
    class Meta:
        fields = ("SID", "name", "email")

# Init Schema
super_schema = SuperSchema(strict = True)
supers_schema = SuperSchema(many=True, strict=True)

# Create a Super Row
@app.route('/super', methods=['POST'])
def add_super():
    SID = request.json['SID']
    name = request.json['name']
    email = request.json['email']

    new_super = Super(SID, name, email)

    db.session.add(new_super)
    db.session.commit()

    # returns the created json 
    return super_schema.jsonify(new_super)

# GET All Super
@app.route('/super', methods=['GET'])
def get_supers():
    all_supers = Super.query.all()
    result = supers_schema.dump(all_supers)
    return jsonify(result.data)

# GET Single Product
@app.route('/super/<SID>', methods=['GET'])
def get_super(SID):
    single_super = Super.query.get(SID)
    result = super_schema.dump(single_super)
    return jsonify(result.data)

# Update a Super Row
@app.route('/super/<SID>', methods=['PUT'])
def update_super(SID):
    single_super = Super.query.get(SID)

    SID = request.json['SID']
    name = request.json['name']
    email = request.json['email']

    single_super.SID = SID
    single_super.name = name
    single_super.email = email 

    db.session.commit()

    # returns the created json 
    return super_schema.jsonify(single_super)

# Delete Product
@app.route('/super/<SID>', methods=['DELETE'])
def delete_super(SID):
    single_super = Super.query.get(SID)
    db.session.delete(single_super)
    db.session.commit()
    return super_schema.jsonify(single_super)

# Run server
if __name__ == '__main__':
    app.run(debug=True)


