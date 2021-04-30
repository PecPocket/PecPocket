#pylint: disable-all


from flask import Blueprint, Response, request, jsonify, send_from_directory, current_app, app
import os
from os.path import dirname

studyblue = Blueprint("studyblue", __name__)

path = dirname(dirname(os.path.abspath(__file__)))
file_path = path + '/static'


def config(app):
    with app.app_context():
        app.config['STUDY_IMAGES'] = file_path


@studyblue.route('/upload/<subject_code>', methods=['POST'])
def upload(subject_code):
    # check if file is there
    if not request.files['file']:
        # there is no file, empty upload 
        return jsonify({'code':404})

    current_file = request.files['file']
    file_name = current_file.filename

    #check if the dir already exists or not
    file_path = path + "/static/" + subject_code

    if not os.path.isdir(file_path):
        os.mkdir(file_path)

    current_file.save(os.path.join(file_path, file_name))
    return jsonify({'code':200})


@studyblue.route('/getuploads/<subject_code>', methods=['GET'])
def get_image_uploads(subject_code):
    #get list from static images
    file_path = path + '/static/' + subject_code

    # if the directory is not there 
    if not os.path.isdir(file_path):
        return jsonify({'code':405})

    dir_list = os.listdir(file_path)

    if not dir_list:
        #empty uploads 
        return jsonify({'code':406})

    return jsonify({'Uploads': dir_list})


@studyblue.route('/download/<subject_code>/<image_name>',  methods=['GET'])
def download_image(subject_code, image_name):
    file_path = path + '/static/' + subject_code

    # check if the file exists
    try:
        return send_from_directory(
            file_path, filename = image_name, as_attachment = True
        )

    except FileNotFoundError:
        # file not found
        return jsonify({'code': 404})

    

