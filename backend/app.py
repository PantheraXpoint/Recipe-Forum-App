import os
from time import time

from flask import Flask, request, Response, jsonify, make_response, send_file
from flask_mongoengine import MongoEngine
from models.RecipeDetail import RecipeDetail
from models.RecipePreview import RecipePreview
import pymongo

app = Flask(__name__)

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb+srv://QuangTau:panthera02@cluster0.g3n9q.mongodb.net/RECIPE_APP'
}

db = MongoEngine()
db.init_app(app)

<<<<<<< HEAD
# path to image saving
uploads_dir = os.path.join(app.instance_path, 'images')
=======
    flash('Logged in successfully.')

    # NEXT = pop from frontend navigation stack
    # return redirect( url_for('getProfile') )

    # return make_response( {"status": "Failed", "message": "Login failed"}, 400)
    try:
        t = (flask_login.current_user.serialize)
        return make_response( {"status": "OK", "current user": t['email']}, 200)
    except:
        return make_response( {"status": "Forbidden", "message": 'not logged in' }, 403)

#test loginrequired
@app.route('/profile', methods=["GET"])
@flask_login.login_required
def getProfile():
    try:
        t = (flask_login.current_user.serialize)
        return make_response( {"status": "OK", "current user": t['email']}, 200)
    except:
        return make_response( {"status": "Forbidden", "message": 'not logged in' }, 403)
>>>>>>> 1f99817008314c147568e32aacad7472a9d0fb21

@app.route('/recipe', methods=["GET"])
def list_recipe_preview():
    recipes = RecipePreview.objects[:int(request.form.get('limit'))].to_json()
    return Response(recipes, mimetype="application/json", status=200)

@app.route('/recipe-list/<int:frm>-<int:too>', methods=["GET"])
def browse_recipe(lim):
    recipes = RecipePreview.objects[frm:too].to_json()
    return Response(recipes, mimetype="application/json", status=200)

@app.route('/recipe-detail', methods=["GET", "POST"])
def handle_recipe_detail():
    if (request.method == "GET"):
        recipes = RecipeDetail.objects.to_json()
        return Response(recipes, mimetype="application/json", status=200)
    elif (request.method == "POST"):
        body = request.get_json()
        movie = RecipeDetail(**body).save()

        return jsonify(movie), 200


@app.route('/recipe/<id>', methods=['DELETE'])
def deleteRecipe(id):
    RecipeDetail.objects.get(id=id).delete()
    return 'delete successful', 200


@ app.route('/image/<string:filename>', methods=['GET'])
def handle_image(filename):
    try:
        print(os.path.join(uploads_dir, filename))
        return send_file(os.path.join(uploads_dir, filename), mimetype='image/jpg')
    except:
        return make_response({'status':'Not found', 'message' : 'file not found'},404)

@ app.route('/image', methods=['POST'])
def send_image():
    saved_image = request.files["image"]
    img_name = str(time())+'.jpg'
    saved_image.save(os.path.join(uploads_dir, img_name))
    return make_response({'status':'OK', 'filename':img_name},200)

if __name__ == '__main__':
    app.run(debug=True, port='4996')
