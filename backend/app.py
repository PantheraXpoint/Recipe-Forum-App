import os
from time import time

from flask import Flask, request, Response, jsonify, make_response, send_file
from flask_mongoengine import MongoEngine
from models.RecipeDetail import RecipeDetail
from models.RecipePreview import RecipePreview
from bson import ObjectId
import pymongo

app = Flask(__name__)

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb+srv://QuangTau:panthera02@cluster0.g3n9q.mongodb.net/RECIPE_APP'
}

db = MongoEngine()
db.init_app(app)

# path to image saving
uploads_dir = os.path.join(app.instance_path, 'images')

@app.route('/recipe', methods=["GET"])
def list_recipe_preview():
    try:
        if request.form.get('limit'):
            lim = int(request.form.get('limit'))
        else:
            lim = 10
        recipes = RecipePreview.objects[:lim].only("Name","AvgRating","Img","Level","TotalTime","Id").to_json()
        
        return Response(recipes, mimetype="application/json", status=200)
    except:
        return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

# @app.route('/recipe-list/<int:frm>-<int:too>', methods=["GET"])
# def browse_recipe(lim):
#     recipes = RecipePreview.objects[frm:too].only("Name","AvgRating","Img","Level","TotalTime").to_json()
#     return Response(recipes, mimetype="application/json", status=200)

@app.route('/recipe-detail', methods=["GET", "POST"])
def handle_recipe_detail():
    if (request.method == "GET"):
        recipes = RecipeDetail.objects.to_json()
        return Response(recipes, mimetype="application/json", status=200)
    elif (request.method == "POST"):
        body = request.get_json()
        movie = RecipeDetail(**body).save()

        return jsonify(movie), 200

@app.route('/recipe-detail/<id>', methods=['DELETE','GET'])
def oneRecipe(id):
    if request.method == 'GET':
        recipes = RecipeDetail.objects(id=id).only("steps","ingredients","photos","totalLike","avgRating","totalRating","totalTime","description","name").to_json()
        return Response(recipes, mimetype="application/json", status=200)
    elif request.method == 'DELETE':
        RecipeDetail.objects(id=id).delete()
        return 'delete successful', 200

#
#   Image handling
#
@ app.route('/image/<string:filename>', methods=['GET'])
def handle_image(filename):
    try:
        print(os.path.join(uploads_dir, filename))
        return send_file(os.path.join(uploads_dir, filename), mimetype='image/jpg')
    except:
        return make_response({'status':'Bad request', 'message' : 'File not found, or the requested file has the wrong extension'},400)

from imghdr import what

@ app.route('/image', methods=['POST'])
def send_image():
    saved_image = request.files["image"]
    print(what(saved_image))
    img_name = str(time())+'.jpg'
    saved_image.save(os.path.join(uploads_dir, img_name))
    return make_response({'status':'OK', 'filename':img_name},200)

if __name__ == '__main__':
    app.run(debug=True, port='4996')
