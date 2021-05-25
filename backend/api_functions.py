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


def makeANewRecipe(title, desc, img):
    addedrecipe = Recipe(title=title, desc = desc, img = img)
    session.add(addedrecipe)
    session.commit()
    return jsonify(Recipe=addedbook.serialize)


def updateRecipe(id, title, desc, img):
    updatedRecipe = session.query(Recipe).filter_by(id=id).one()
    if not title:
        updatedRecipe.title = title
    if not author:
        updatedRecipe.desc = desc
    if not genre:
        updatedRecipe.img = img
    session.add(updatedRecipe)
    session.commit()
    return 'Updated a Recipe with id %s' % id


def deleteARecipe(id):
    recipeToDelete = session.query(Recipe).filter_by(id=id).one()
    session.delete(recipeToDelete)
    session.commit()
    return 'Removed Recipe with id %s' % id


def get_preview():
    recipes = session.query(Recipe.id, Recipe.title, Recipe.img).all()
    print(recipes)
    lst = []
    for res in recipes:
        lst.append({'id' : res[0] , 'title': res[1], 'img': res[2]})
    return jsonify(lst)