from flask import Flask, render_template, request, redirect, url_for, jsonify, make_response
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database_setup import Base, Recipe
from flask import send_file
from pathlib import Path
import os
from werkzeug.utils import secure_filename
from time import time
from api_functions import *

app = Flask(__name__)

uploads_dir = os.path.join(app.instance_path, 'images')

# Connect to Database and create database session
engine = create_engine(
    'sqlite:///recipes-collection.db?check_same_thread=False')
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()


# landing page that will display all the recipes in our database
# This function will operate on the Read operation.

@app.route('/')
def defaultPage():
    response = make_response(
        jsonify({"status": "OK", "message": "Init server successfully"}),
        400,
    )
    response.headers["Content-Type"] = "application/json"
    return response


@app.route('/recipe', methods=["GET"])
def showRecipe():
    recipeId = request.args.get("recipeId")
    queryRecipe = session.query(Recipe).filter_by(id=recipeId).one()
    print(queryRecipe)
    return make_response(queryRecipe.serialize(), 200)


# This will let us Create a new recipe and save it in our database
@app.route('/recipe', methods=['POST'])
def addRecipe():
    if (request.json):
        newRecipe = Recipe(**request.json)
        print()
        return make_response({"status": "OK", "data), "message": "Tạo công thức thành công"}, 200)
   #  newRecipe = Recipe(title=request.form['title'],
   #                     desc=request.form['desc'],
   #                     img=request.form['img'])
   #  session.add(newRecipe)
   #  session.commit()
   #  # return redirect(url_for('showRecipe'))


# This will let us Update our recipes and save it in our database
@ app.route("/recipes/<int:recipe_id>/edit/", methods=['GET', 'POST'])
def editRecipe(recipe_id):
    editedRecipe = session.query(Recipe).filter_by(id=recipe_id).one()
    if request.method == 'POST':
        if request.form['name']:
            editedRecipe.title = request.form['name']
            return redirect(url_for('showRecipes'))
    else:
        return render_template('editRecipe.html', recipe=editedRecipe)


# This will let us Delete our recipe
@ app.route('/recipes/<int:recipe_id>/delete/', methods=['GET', 'POST'])
def deleteRecipe(recipe_id):
    recipeToDelete = session.query(Recipe).filter_by(id=recipe_id).one()
    if request.method == 'POST':
        session.delete(recipeToDelete)
        session.commit()
        return redirect(url_for('showRecipes', recipe_id=recipe_id))
    else:
        return render_template('deleteRecipe.html', book=recipeToDelete)


@ app.route('/')
@ app.route('/recipesApi', methods=['GET', 'POST'])
def recipesFunction():
    if request.method == 'GET':
        return get_recipes()
    elif request.method == 'POST':
        title = request.args.get('title', '')
        desc = request.args.get('desc', '')
        img = request.args.get('img', '')
        return makeANewRecipe(title, desc, img)


@ app.route('/recipesApi/<int:id>', methods=['GET', 'PUT', 'DELETE'])
def recipeFunctionId(id):
    if request.method == 'GET':
        return get_recipe(id)

    elif request.method == 'PUT':
        title = request.args.get('title', '')
        desc = request.args.get('desc', '')
        img = request.args.get('img', '')
        return updateRecipe(id, title, desc, img)

    elif request.method == 'DELETE':
        return deleteARecipe(id)


@ app.route('/recipesApiBrowse', methods=['GET'])
def recipeBrows():
    return get_preview()


@ app.route('/getImage', methods=['GET'])
def get_image():
    filename = request.args.get('filename', '')

    return send_file(os.path.join(uploads_dir, filename), mimetype='image/jpg')


@ app.route('/sendImage', methods=['GET', 'POST'])
def send_image():
    if request.method == 'POST':
        profile = request.files["image"]
        img_name = str(time())+'.jpg'
        profile.save(os.path.join(uploads_dir, img_name))
    return 'Uploaded filename is {}'.format(img_name)


if __name__ == '__main__':
    app.run(debug=True, port='8081')
