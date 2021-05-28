import os
from pathlib import Path
from time import time

import flask_login
from flask import (Flask, flash, jsonify, make_response, redirect,
                   render_template, request, send_file, session, url_for)
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from api_functions import *
from database_setup import Account, Base, Recipe

app = Flask(__name__)
app.secret_key = b'supasecretstring'

uploads_dir = os.path.join(app.instance_path, 'images')

# Connect to Database and create database dbsession
engine = create_engine(
    'sqlite:///recipes-collection.db?check_same_thread=False')
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
dbsession = DBSession()

# login manager from flask_login
login_manager = flask_login.LoginManager()
login_manager.init_app(app)

#   Cookie loader
@login_manager.user_loader
def load_user(user_id):
    return getAccount(user_id)

# #   Login from request
# @login_manager.request_loader
# def load_user_from_request(request):

#     # # first, try to login using the api_key url arg
#     # api_key = request.args.get('api_key')
#     # if api_key:
#     #     user = User.query.filter_by(api_key=api_key).first()
#     #     if user:
#     #         return user

#     # next, try to login using Basic Auth
#     api_key = request.headers.get('Authorization')
#     if api_key:
#         api_key = api_key.replace('Basic ', '', 1)
#         try:
#             api_key = base64.b64decode(api_key)
#         except TypeError:
#             pass
#         user = User.query.filter_by(api_key=api_key).first()
#         if user:
#             return user

#     # finally, return None if both methods did not login the user
#     return None

@app.route('/')
def defaultPage():
    response = make_response(
        jsonify({"status": "OK", "message": "Server initialized successfully"}),
        400,
    )
    response.headers["Content-Type"] = "application/json"
    return response

@app.route('/register', methods=["POST"])
def registerAccount():
    email = request.form.get('email','')
    password = request.form.get('password','')
    if email == '' or password == '':
        return make_response( {"status": "Missing parameter", "message": "Please enter an email and a password"}, 201)
    
    result = createAccount(email, password)
    if result:
        return make_response( {"status": "OK", "message": "Account created successfully"}, 200)
    return make_response( {"status": "Conflict", "message": "Account with this email already existed"}, 400)

@app.route('/accounts', methods=['GET'])
def getListAccount():
    return getAccountList()

@app.route('/deleteaccount', methods = ['DELETE'])
def deleteAccount():
    t = removeAccount( request.form.get('email') )
    if t:
        return make_response( {"status": "OK", "message": "Account deleted successfully"}, 200)
    return make_response( {"status": "Not found", "message": "Selected account was not found"}, 400)

@app.route('/login', methods=['GET', 'POST'])
def login():
    # Here we use a class of some kind to represent and validate our
    # client-side form data. For example, WTForms is a library that will
    # handle this for us, and we use a custom LoginForm to validate.
    # Login and validate the user.
    # user should be an instance of your `User` class
    account = checkinAccount( request.form.get('email','') , request.form.get('password',''))

    if account == 0:
        return make_response( {'status': 'Bad request', 'message':'Entered email is incorrect'}, 400 )
    if account == -1:
        return make_response( {'status': 'Forbidden', 'message':'Entered password is incorrect'}, 403 )

    flask_login.login_user(account)

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

# get one recipe
@app.route('/recipe', methods=["GET"])
def showRecipe():
    recipeId = request.args.get("recipeId")
    queryRecipe = dbsession.query(Recipe).filter_by(id=recipeId).one()
    print(queryRecipe)
    if flask_login.current_user.is_authenticated:
        print('hey you are logged in')
    return make_response(queryRecipe.serialize(), 200)

# This will let us Update our recipes and save it in our database
@ app.route("/recipes/<int:recipe_id>/edit/", methods=['PUT'])
def editRecipe(recipe_id):
    editedRecipe = dbsession.query(Recipe).filter_by(id=recipe_id).one()
    if request.method == 'PUT':
        if request.form['name']:
            editedRecipe.title = request.form['name']
            return make_response( {"status": "OK", "message": "Recipe editted succesfully"}, 200)

# delete one recipe
@ app.route('/recipes/<int:recipe_id>/delete/', methods=['DELETE'])
def deleteRecipe(recipe_id):
    try:
        recipeToDelete = dbsession.query(Recipe).filter_by(id=recipe_id).one()
        if request.method == 'DELETE':
            dbsession.delete(recipeToDelete)
            dbsession.commit()
            return make_response( {"status": "OK", "message": "Recipe deleted successfully"}, 200)
    except:
        return make_response( {"status": "Not found", "message": "Selected recipe was not found"}, 400)

# get all recipe
@ app.route('/recipesApi', methods=['GET'])
def recipesFunction():
    if request.method == 'GET':
        return get_recipes()

@app.route('/recipes/new', methods = ['POST'] )
@flask_login.login_required
def postRecipe():
    if request.method == 'POST':
        title = request.form.get('title', '')
        desc = request.form.get('desc', '')
        img = request.form.get('img', '')
        author = flask_login.current_user.get_id()
        return makeANewRecipe(title, desc, img, author)

@ app.route('/recipesApi/<int:id>', methods=['GET', 'PUT', 'DELETE'])
def recipeFunctionId(id):
    try:
        if request.method == 'GET':
            return get_recipe(id)

        elif request.method == 'PUT':
            title = request.args.get('title', '')
            desc = request.args.get('desc', '')
            img = request.args.get('img', '')
            return updateRecipe(id, title, desc, img)

        elif request.method == 'DELETE':
            return deleteARecipe(id)
    except:
        make_response( {"status": "Not found", "message": "Selected recipe was not found"}, 400)



@ app.route('/recipesBrowse', methods=['GET'])
def recipeBrows():
    return get_preview()


@ app.route('/getImage/<string:filename>', methods=['GET'])
def get_image(filename):
    try:
        return send_file(os.path.join(uploads_dir, filename), mimetype='image/jpg')
    except:
        return make_response({'status':'Not found', 'message' : 'file not found'},404)

@ app.route('/sendImage', methods=['POST'])
def send_image():
    saved_image = request.files["image"]
    img_name = str(time())+'.jpg'
    saved_image.save(os.path.join(uploads_dir, img_name))
    return make_response({'status':'OK', 'filename':img_name},200)


if __name__ == '__main__':
    app.run(debug=True, port='4996')
