from flask import Flask, render_template, request, redirect, url_for

app = Flask(__name__)

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database_setup import Base, Recipe

# Connect to Database and create database session
engine = create_engine('sqlite:///recipes-collection.db?check_same_thread=False')
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()


# landing page that will display all the books in our database
# This function will operate on the Read operation.
@app.route('/')
@app.route('/recipes')
def showRecipe():
    recipes = session.query(Recipe).all()
    return render_template('books.html', books=recipes)


# This will let us Create a new book and save it in our database
@app.route('/recipes/new/', methods=['GET', 'POST'])
def newRecipe():
    if request.method == 'POST':
        newRecipe = Recipe(title=request.form['name'],
                       desc=request.form['desc'],
                       img=request.form['img'])
        session.add(newRecipe)
        session.commit()
        return redirect(url_for('showRecipes'))
    else:
        return render_template('newRecipe.html')


# This will let us Update our books and save it in our database
@app.route("/recipes/<int:recipe_id>/edit/", methods=['GET', 'POST'])
def editRecipe(recipe_id):
    editedRecipe = session.query(Recipe).filter_by(id=recipe_id).one()
    if request.method == 'POST':
        if request.form['name']:
            editedRecipe.title = request.form['name']
            return redirect(url_for('showRecipes'))
    else:
        return render_template('editRecipe.html', recipe=editedRecipe)


# This will let us Delete our book
@app.route('/recipes/<int:recipe_id>/delete/', methods=['GET', 'POST'])
def deleteRecipe(recipe_id):
    recipeToDelete = session.query(Recipe).filter_by(id=recipe_id).one()
    if request.method == 'POST':
        session.delete(recipeToDelete)
        session.commit()
        return redirect(url_for('showRecipes', recipe_id=recipe_id))
    else:
        return render_template('deleteRecipe.html', book=recipeToDelete)


"""
api functions
"""
from flask import jsonify


def get_recipes():
    recipes = session.query(Recipe).all()
    return jsonify(recipes=[b.serialize for b in recipes])


def get_recipe(recipe_id):
    recipes = session.query(Recipe).filter_by(id=recipe_id).one()
    return jsonify(recipes=recipes.serialize)

def get_preview():
    recipes = session.query(Recipe.id, Recipe.title, Recipe.img).all()

    temp = []
    
    for b in recipes:
        temp.append( {'id':b[0], 'title':b[1], 'img':b[2]} )

    return jsonify(temp)
    # return jsonify( id=[b[0] for b in recipes], 
    #                 title= [b[1] for b in recipes], 
    #                 img= [b[2] for b in recipes] )

def makeANewRecipe(title, desc, img):
    addedrecipe = Recipe(title=title, desc=desc, img=img)
    session.add(addedrecipe)
    session.commit()
    return jsonify(Recipe=addedrecipe.serialize)


def updateRecipe(id, title, desc, img):
    updatedRecipe = session.query(Recipe).filter_by(id=id).one()
    if not title:
        updatedRecipe.title = title
    if not desc:
        updatedRecipe.desc = desc
    if not img:
        updatedRecipe.img = img
    session.add(updatedRecipe)
    session.commit()
    return 'Updated a Recipe with id %s' % id


def deleteARecipe(id):
    recipeToDelete = session.query(Recipe).filter_by(id=id).one()
    session.delete(recipeToDelete)
    session.commit()
    return 'Removed recipe with id %s' % id


@app.route('/')
@app.route('/recipesApi', methods=['GET', 'POST'])
def recipesFunction():
    if request.method == 'GET':
        return get_recipes()
    elif request.method == 'POST':
        title = request.args.get('title', '')
        desc = request.args.get('desc', '')
        img = request.args.get('img', '')
        return makeANewRecipe(title, desc, img)


@app.route('/recipesApi/<int:id>', methods=['GET', 'PUT', 'DELETE'])
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

@app.route('/recipesApiBrowse', methods=['GET'])
def recipeBrows():
    if request.method == 'GET':
        return get_preview()

if __name__ == '__main__':
    app.debug = True
    app.run(host='0.0.0.0', port=4996)
