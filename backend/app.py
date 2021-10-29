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
# from models.RecipePreview import RecipePreview

app = Flask(__name__)
app.secret_key = b'supasecretstring'

app.config['MONGODB_SETTINGS'] = {
    'host': 'mongodb+srv://QuangTau:panthera02@cluster0.g3n9q.mongodb.net/RECIPE_APP?ssl=true&ssl_cert_reqs=CERT_NONE'
}

# mongoengine init for queries
db = MongoEngine()
db.init_app(app)

# login manager from flask_login
login_manager = flask_login.LoginManager()
login_manager.init_app(app)

# path to image saving
uploads_dir = os.path.join(app.instance_path, 'images')

#   Cookie login loader
@login_manager.user_loader
def load_user(user_id):
    return queryId(user_id)

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
def logoutAccount():
    try:
        flask_login.logout_user()
        return make_response( {"status": "OK", "message": "Logout successful"}, 200)
    except:
        return make_response( {"status": "uh oh", "message": "something went wrong"}, 400)

#
#   Account handling
#
@app.route('/account/<username>', methods=["GET"])
def accountLookup(username):
    try :
        acc = queryUsername(username)
        if len(acc) == 0:
            return make_response( {"status": "Not found", "message": "Account not found, maybe it is deleted"}, 404)
        return jsonify(acc) ,200
    except:
        return make_response( {"status": "Missing paramter", "message": "Enter an username after the url please"}, 400)

@app.route('/account/<username>/recipe', methods=["GET"])
def creationLookup(username):
    recipe = queryCreation(username)
    return jsonify(recipe), 200

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

@app.route('/myprofile/edit', methods=['PUT'])
@flask_login.login_required
def editAccount():
    user = flask_login.current_user
    body = request.get_json()
    if body == None:
        return make_response( {"status": "OK", "message": "nothing changed"}, 200)
    
    password = body["PassWord"]
    if checkinAccount(user.get_username(), password) == 0:
        return make_response( {"status": "Forbidden", "message": "Old password is incorrect"}, 403)
    
    try:
        newpassword = body["NewPassWord"]
        
        user.update(
            PassWord = generate_password_hash(newpassword),
            FirstName = body.get("FirstName", user["FirstName"]),
            LastName = body.get("LastName", user["LastName"]),
            DisplayName = body.get("DisplayName", user["DisplayName"]),
            AvatarUrl = body.get("AvatarUrl", user["AvatarUrl"])
        )
        user.save()
        updateduser = Profile.objects(Id=user.get_id())
        return jsonify(updateduser), 200

    except:
        user.update(
            FirstName = body.get("FirstName", user["FirstName"]),
            LastName = body.get("LastName", user["LastName"]),
            DisplayName = body.get("DisplayName", user["DisplayName"]),
            AvatarUrl = body.get("AvatarUrl", user["AvatarUrl"])
        )
        user.save()
        updateduser = Profile.objects(Id=user.get_id())
        return jsonify(updateduser), 200

@app.route('/myprofile/delete', methods=['DELETE'])
@flask_login.login_required
def deleteCurrentAccount():
    user = flask_login.current_user
    body = request.get_json()
    if body == None:
        return make_response( {"status": "OK", "message": "nothing changed"}, 200)

    password = body["PassWord"]
    if checkinAccount(user.get_username(), password) == 0:
        return make_response( {"status": "Forbidden", "message": "Password is incorrect"}, 403)
    
    username = user.get_username()
    flask_login.logout_user()
    Profile.objects(UserName=username).delete()
    return make_response( {"status": "OK", "message": "Account successfully deleted"}, 200)

@app.route('/mycollection', methods=['GET'])
@flask_login.login_required
def getMyCollection():
    user = flask_login.current_user
    lst = user.get_collection()
    result = []
    for id in lst:
        result.append(getRecipeObject(id).generatePreview())
    
    return jsonify(result),200

@app.route("/myprofile")
@flask_login.login_required
def getMyProfile():
    return jsonify(flask_login.current_user)

@app.route("/myprofile/recipe")
@flask_login.login_required
def getMyCreations():
    return jsonify(queryCreation( flask_login.current_user["UserName"] )), 200

#
#       Recipe request handling
#
@app.route('/recipe', methods=["GET"])
def listRecipePreview():
    try:
        lim = request.get_json()['limit']
        recipes = queryBrowse(lim)
        return jsonify(recipes)
        # return Response(recipes, mimetype="application/json", status=200)
    except:
        try:
            if request.form.get('limit'):
                lim = int(request.form.get('limit'))
            else:
                lim = 100
            recipes = queryBrowse(lim)
            
            return jsonify(recipes)
        except:
            return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

@app.route('/recipe/<int:limitt>', methods=["GET"])
def listRecipePreviewArg(limitt):
    try:
        recipes = queryBrowse(limitt)
        return jsonify(recipes)
        # return Response(recipes, mimetype="application/json", status=200)
    except:
        return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

@app.route('/recipe/search', methods=["GET"])
def nameSearch():
    recipe_name = request.args.get('name')
    typee = request.args.get('TypeID',None)
    if typee:
        recipes = textSearchPreview(recipe_name, typee)
    else:
        recipes = textSearchPreview(recipe_name)
    return jsonify( recipes ), 200

# @app.route('/recipe-list/<int:frm>-<int:too>', methods=["GET"])
# def browse_recipe(lim):
#     recipes = RecipePreview.objects[frm:too].only("Name","AvgRating","Img","Level","TotalTime").to_json()
#     return Response(recipes, mimetype="application/json", status=200)

@app.route('/recipe-detail', methods=["GET"])
def getRecipeDetail():
    recipes = RecipeDetail.objects
    return jsonify(recipes),200

@app.route('/recipe-detail', methods=["POST"])
@flask_login.login_required
def postRecipeDetail():

    user = flask_login.current_user

    body = request.get_json()
    recipe = RecipeDetail(**body)
    recipe['creator'] = user.generateCreator()
    recipe.save()
    
    user.add_recipe_count(1)
    # user.save()
    # templist = RecipeDetail.objects(name=recipe.name)
    # tempId = templist[templist.count()-1].getId()
    # preview = recipe.generatePreview()
    # preview['Id'] = tempId
    # preview.save()

    return jsonify(recipe), 200

@app.route('/recipe-detail/<id>', methods=['GET'])
def oneRecipe(id):
    try:
        recipes = queryRecipe(id)
        return jsonify(recipes)
    except:
        return make_response({'status':'Not found', 'message' : 'Recipe not found'},404)

@app.route('/recipe-detail/<id>', methods=['DELETE'])
@flask_login.login_required
def delRecipe(id):
    recipe = RecipeDetail.objects(id=id).first()
    if recipe:
        if recipe.checkCreator( flask_login.current_user.get_username() ):
            deleteRecipe( int(id) )
            flask_login.current_user.add_recipe_count(-1)
            return make_response({'status':'OK', 'message' : 'Recipe deleted'},200)
        return make_response({'status':'Forbidden', 'message' : 'You do not own this recipe'},403)
    return make_response({'status':'Not Found', 'message' : 'Recipe was not found'},404)

@app.route('/recipe-detail/<id>/view', methods = ['PUT'])
def increaseView(id):
    try:
        incrementViewCount(id)
        return make_response({'status':'OK', 'message' : 'View incremented'},200)
    except:
        return make_response({'status':'Bad Request', 'message' : 'Something went wrong'},400)

@app.route('/recipe-detail/<int:ide>/rate', methods=['PUT'])
@flask_login.login_required
def rateePost(ide):
    if len(RecipeDetail.objects(id=ide)) == 0 :
        return make_response( {"status": "Not found", "message": "Recipe was not found"}, 404)
    try:
        star = request.get_json()["rating"]
    except:
        return make_response( {"status": "Bad request", "message": "Request body is incorrect"}, 400)
    
    user = flask_login.current_user
    user_id = user.get_id()
    if user.rated(ide):
        newrating = updateRating(user_id, ide, star)
        return make_response( {"status": "OK", "message": "Previous rating changed", "avgRating": newrating}, 200)

    newrating = ratePost( user_id, ide, star )
    return make_response( {"status": "OK", "message": "New rating submited", "avgRating": newrating}, 200)

@app.route('/recipe-detail/<int:ide>/save', methods=['PUT'])
@flask_login.login_required
def saveIntoCollection(ide):
    user = flask_login.current_user
    if len(RecipeDetail.objects(id=ide)) == 0:
        return make_response( {"status": "Not Found", "message": "Recipe not found"}, 404)

    if user.check_collection(ide):
        user.save_to_collection(ide)
        user.save()
        return make_response( {"status": "OK", "message": "Recipe added to collection"}, 200)
    else:
        # user.remove_from_collection(ide)
        return make_response( {"status": "Bad request", "message": "Recipe already in collection"}, 400)

@app.route('/recipe-detail/<int:ide>/unsave', methods=['PUT'])
@flask_login.login_required
def removeFromCollection(ide):
    user = flask_login.current_user
    if len(RecipeDetail.objects(id=ide)) == 0:
        return make_response( {"status": "Not Found", "message": "Recipe not found"}, 404)

    if user.check_collection(ide):
        return make_response( {"status": "Bad request", "message": "Recipe not in collection"}, 400)
    else:
        user.remove_from_collection(ide)
        user.save()
        return make_response( {"status": "OK", "message": "Recipe removed from collection"}, 200)

@app.route('/recipe-detail/<int:ide>/edit', methods=['PUT'])
@flask_login.login_required
def editRecipe(ide):
    
    body = request.get_json()
    
    if body == None:
        return make_response( {"status": "OK", "message": "nothing was changed because nothing was in the request body"}, 200)
    
    respon = editRecipeFunc(flask_login.current_user.get_username(), ide, body)
    if respon == 200:
        return make_response({'status':'OK', 'message' : 'Recipe edited'},200)
    if respon == 500:
        return make_response({'status':'Internal server error', 'message' : 'Something wrong happened during editing recipe'},500)
    if respon == 403:
        return make_response({'status':'Forbidden', 'message' : 'You do not own this recipe'},403)
    if respon == 404:
        return make_response({'status':'Not Found', 'message' : 'Recipe was not found'},404)


# @app.route('/nuclearoption', methods = ['GET'])
# def debugme():
#     temp = {}
#     dupe = []
#     recipes = RecipeDetail.objects
#     for recipe in recipes:
#         if recipe["id"] in temp:
#             temp[recipe["id"]] += 1
#         else:
#             temp.update( {recipe["id"] : 0} )
#     # for ele in temp:
#     #     if temp[ele] > 0:
#     #         badoptimiz.update( {ele : temp[ele]} )
#     # for ids in dupe:
#         # rep = RecipeDetail.objects(id=ids).delete()
#         # print(rep)
#         # rep.delete()
#     return jsonify(temp)

#
#   Image handling
#
@ app.route('/image/<string:filename>', methods=['GET'])
def handleImage(filename):
    try:
        print(os.path.join(uploads_dir, filename))
        return send_file(os.path.join(uploads_dir, filename), mimetype='image/jpg')
    except:
        return make_response({'status':'Bad request', 'message' : 'File not found, or the requested file has the wrong extension'},400)

@app.route('/image', methods=['POST'])
def receiveImage():
    saved_image = request.files["image"]
    # print(what(saved_image))
    img_name = str(time())+'.jpg'
    saved_image.save(os.path.join(uploads_dir, img_name))
    return make_response({'status':'OK', 'filename':img_name},200)

@app.route('/images', methods=['POST'])
def receiveManyImages():
    lst = {}
    try:
        for key in request.files:
            imag = request.files[key]
            img_name = str(time())+'.jpg'
            imag.save(os.path.join(uploads_dir, img_name))
            lst.update( {key:img_name} )
        return jsonify(lst),200
    except:
        return make_response({'status':'Something went wrong', 'message':"Internal server error"},400)

if __name__ == '__main__':
    app.run(debug=True, port='4996')
