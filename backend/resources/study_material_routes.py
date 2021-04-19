#pylint: disable-all


from flask import Blueprint, Response, request, jsonify, send_from_directory, abort, current_app
import os
from os.path import dirname

# studyblue = Blueprint("studyblue", __name__, None)

# path = dirname(dirname(os.path.abspath(__file__)))

# images_path = path + "/static/images"

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
    

