#pylint: disable-all


from flask import Blueprint, Response, request, jsonify, send_from_directory, current_app, app
import os
from os.path import dirname

studyblue = Blueprint("studyblue", __name__)

path = dirname(dirname(os.path.abspath(__file__)))
images_path = path + "/static/images"
pdfs_path = path + "/static/pdf"

def config(app):
    with app.app_context():
        app.config['STUDY_IMAGES'] = images_path
        app.config['STUDY_PDFS'] = pdfs_path


#app.config['STUDY_IMAGES'] = images_path

@studyblue.route('/upload/image', methods=['POST'])
def upload_image():
    # check if file is there
    if not request.files['image']:
        # there is no file, empty upload 
        return jsonify({'code':503})

    current_file = request.files['image']
    file_name = current_file.filename
    current_file.save(os.path.join(images_path, file_name))

    return jsonify({'code':200})


@studyblue.route('/upload/pdf', methods=['POST'])
def upload_pdf():
    # check if file is there
    if not request.files['pdf']:
        # there is no file, empty upload
        return jsonify({'code':503})

    current_file = request.files['pdf']
    file_name = current_file.filename
    current_file.save(os.path.join(pdfs_path, file_name))

    return jsonify({'code':200})

@studyblue.route('/download/image/<image_name>',  methods=['GET'])
def download_image(image_name):
    # check if the file exists
    try:
        return send_from_directory(
            images_path, filename = image_name, as_attachment = True
        )

    except FileNotFoundError:
        # file not found
        return jsonify({'code': 504})


@studyblue.route('/download/pdf/<pdf_name>',  methods=['GET'])
def download_pdf(pdf_name):
    # check if the file exists
    try:
        return send_from_directory(
            pdfs_path, filename = pdf_name, as_attachment = True
        )

    except FileNotFoundError:
        # file not found
        return jsonify({'code': 504})





# studyblue.config = {}

# @studyblue.record
# def record_params(setup_state):
#     app = setup_state.app
#     studyblue.config = dict([(key,value) for (key,value) in app.config.items()])

# studyblue.config["study_images"] = images_path


# WE NEED TO CONFIG THIS SOMEHOW TO SEND THESE FILES.




# @studyblue.route("/study/<image_name>", methods=["GET"])
# def get_image(image_name):
#     try:
#         return send_from_directory(studyblue.config["study_images"], filename=image_name, as_attachment=False)
#         # return images_path

#     except FileNotFoundError:
#         return jsonify({"code": 404})
    

