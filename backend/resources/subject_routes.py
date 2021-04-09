#pylint: disable-all

from flask import Blueprint, Response, request, jsonify
from database.models import Subject, SubjectSchema, subject_schema, subjects_schema
from database.extensions import db, ma

subjectblue = Blueprint("subjectblue", __name__)

#Create a Subject Row
@subjectblue.route('/subject', methods=['POST'])
def add_super():
    Branch = request.json['Branch']
    Semester = request.json['Semester']
    Sub_codes = request.json['Sub_codes']
    Elect_codes = request.json['Elect_codes']

    new_subject = Subject(Branch, Semester, Sub_codes, Elect_codes)

    db.session.add(new_subject)
    db.session.commit()

    # returns the created json 
    return subject_schema.jsonify(new_subject)


# Update a Subject Row
@subjectblue.route('/subject/<Branch>/<Semester>', methods=['PUT'])
def update_subject(Branch, Semester):
    subject_detail = Subject.query.get(Branch, Semester)

    Branch = request.json['Branch']
    Semester = request.json['Semester']
    Sub_codes = request.json['Sub_codes']
    Elect_codes = request.json['Elect_codes']

    subject_detail.Branch = Branch
    subject_detail.Semester = Semester
    subject_detail.Sub_codes = Sub_codes
    subject_detail.Elect_codes = Elect_codes

    db.session.commit()

    # returns the created json 
    return jsonify({'code':200})


# Delete Subject
@subjectblue.route('/subject/<Branch>/<Semester>', methods=['DELETE'])
def delete_subject(Branch, Semester):
    subject_detail = Subject.query.get(Branch, Semester)
    db.session.delete(subject_detail)
    db.session.commit()
    return jsonify({'code':200})

