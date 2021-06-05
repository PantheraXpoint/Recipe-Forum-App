import os
from time import time

import flask_login
from flask import Flask, request, Response, jsonify, make_response, send_file
from flask_mongoengine import MongoEngine
from bson import ObjectId
from imghdr import what
import pymongo

from api_functions import *
from models.RecipeDetail import RecipeDetail
from models.RecipePreview import RecipePreview

app = Flask(__name__)
app.secret_key = b'supasecretstring'

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb+srv://QuangTau:panthera02@cluster0.g3n9q.mongodb.net/RECIPE_APP'
}

# mongoengine init for queries
db = MongoEngine()
db.init_app(app)

# login manager from flask_login
login_manager = flask_login.LoginManager()
login_manager.init_app(app)

# path to image saving
uploads_dir = os.path.join(app.instance_path, 'images')

#   Cookie loader
@login_manager.user_loader
def load_user(user_id):
    return queryId(user_id)

#
#   Account handling
#
@app.route('/account/<username>', methods=["GET"])
def accountLookup(username):
    try :
        acc = queryUsername(username)
        if len(acc) == 0:
            return make_response( {"status": "Not found", "message": "Account not found"}, 404)
        return jsonify(acc) ,200
    except:
        return make_response( {"status": "Missing paramter", "message": "Enter an username after the url please"}, 400)

@app.route('/register', methods=['POST'])
def createAccount():
    body = request.get_json()
    if len(queryUsername(body["UserName"])) != 0:
        return make_response( {"status": "Conflict", "message": "Account with this username already existed"}, 400)
    if body == None:
        return make_response( {"status": "Missing paramter", "message": "Put the account credential in the request body please"}, 400)
    acc = Profile(**body)
    acc['PassWord'] = generate_password_hash( body["PassWord"] )
    acc.save()
    return jsonify(acc), 200

#
#       Login handling
#
@app.route('/login',methods=['POST'])
def loginAccount():
    body = request.get_json()
    try:
        username = body["UserName"]
        password = body["PassWord"]
    except:
        return make_response( {"status": "Bad request", "message": "Missing parameters, enter username and password"}, 400)
    
    acc = checkinAccount(username, password)
    if acc == -1:
        return make_response( {"status": "Not found", "message": "Account not found"}, 404)
    if acc == 0:
        return make_response( {"status": "Bad request", "message": "Incorrect password"}, 400)

    flask_login.login_user(acc)

    return jsonify(flask_login.current_user),200

@app.route("/logout")
@flask_login.login_required
def logout():
    try:
        flask_login.logout_user()
        return make_response( {"status": "OK", "message": "Logout successful"}, 200)
    except:
        return make_response( {"status": "uh oh", "message": "something went wrong"}, 400)

@app.route("/myprofile")
@flask_login.login_required
def getMyProfile():
    return jsonify(flask_login.current_user)

#
#       Recipe request handling
#
@app.route('/recipe', methods=["GET"])
def list_recipe_preview():
    try:
        lim = request.get_json()['limit']
        recipes = queryBrowse(lim)
        return Response(recipes, mimetype="application/json", status=200)
    except:
        try:
            if request.form.get('limit'):
                lim = int(request.form.get('limit'))
            else:
                lim = 100
            recipes = queryBrowse(lim)
            
            return Response(recipes, mimetype="application/json", status=200)
        except:
            return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

# @app.route('/recipe-list/<int:frm>-<int:too>', methods=["GET"])
# def browse_recipe(lim):
#     recipes = RecipePreview.objects[frm:too].only("Name","AvgRating","Img","Level","TotalTime").to_json()
#     return Response(recipes, mimetype="application/json", status=200)

@app.route('/recipe-detail', methods=["GET"])
def get_recipe_detail():
    # if (request.method == "GET"):
    recipes = RecipeDetail.objects.to_json()
    return Response(recipes, mimetype="application/json", status=200)
    # elif (request.method == "POST"):

@app.route('/recipe-detail', methods=["POST"])
@flask_login.login_required
def post_recipe_detail():
    body = request.get_json()
    recipe = RecipeDetail(**body)
    recipe['creator'] = flask_login.current_user.generateCreator()
    # print(recipe['name'])
    recipe.save()
    
    name = recipe['name']
    tempid = RecipeDetail.objects(name=name)[0]["id"]
    prev = recipe.generatePreview()
    prev['Id'] = tempid
    prev.save()
    return jsonify(recipe), 200

@app.route('/recipe-detail/<id>', methods=['DELETE','GET'])
def oneRecipe(id):
    if request.method == 'GET':
        recipes = queryRecipe(id)
        return Response(recipes, mimetype="application/json", status=200)
    elif request.method == 'DELETE':
        try:
            deleteRecipe( int(id) )
            return make_response({'status':'OK', 'message' : 'Recipe deleted'},200)
        except:
            return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

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

@ app.route('/image', methods=['POST'])
def send_image():
    saved_image = request.files["image"]
    print(what(saved_image))
    img_name = str(time())+'.jpg'
    saved_image.save(os.path.join(uploads_dir, img_name))
    return make_response({'status':'OK', 'filename':img_name},200)

if __name__ == '__main__':
    app.run(debug=True, port='4996')
