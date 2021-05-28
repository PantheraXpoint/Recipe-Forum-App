from flask import Flask, render_template, request, redirect, url_for
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from database_setup import Base, Recipe, Account
from werkzeug.security import generate_password_hash, check_password_hash
from flask import jsonify

# Connect to Database and create database session
engine = create_engine('sqlite:///recipes-collection.db?check_same_thread=False')
Base.metadata.bind = engine

DBSession = sessionmaker(bind=engine)
session = DBSession()


#
#       Account
#

def getAccountList():
    accounts = session.query(Account.id, Account.email, Account.password).all()
    lst = []
    for res in accounts:
        lst.append({'id': res[0], 'email' : res[1], 'password hash': res[2]})
    return jsonify(lst)

def createAccount(email, password):
    try:
        session.query(Account).filter_by(email=email).one()
        return None
    except:
        newAccount = Account(email = email, password = generate_password_hash(password) )
        session.add(newAccount)
        session.commit()
        return jsonify(Account=newAccount.serialize)

def removeAccount(email):
    try:
        account = session.query(Account).filter_by(email=email).one()
        session.delete(account)
        session.commit()
        return True
    except:
        return False

def checkinAccount(email,password):
    try:
        account = session.query(Account).filter_by(email=email).one()
        if check_password_hash(account.serialize['password'], password):
            return account
        return -1
    except:
        return 0

def getAccount(id):
    account = session.query(Account).filter_by(id=id).one()
    return account

#
#   Recipes
#

def get_recipes():
    recipes = session.query(Recipe).all()
    return jsonify(recipes=[b.serialize for b in recipes])


def get_recipe(recipe_id):
    recipes = session.query(Recipe).filter_by(id=recipe_id).one()
    return jsonify(recipes=recipes.serialize)


def makeANewRecipe(title, desc, img, author):
    addedrecipe = Recipe(title=title, description = desc, image = img, author_id = author)
    session.add(addedrecipe)
    session.commit()
    return jsonify(Recipe=addedrecipe.serialize)


def updateRecipe(id, title, desc, img):
    updatedRecipe = session.query(Recipe).filter_by(id=id).one()
    if not title:
        updatedRecipe.title = title
    if not desc:
        updatedRecipe.description = desc
    if not img:
        updatedRecipe.image = img
    session.add(updatedRecipe)
    session.commit()
    return 'Updated a Recipe with id %s' % id


def deleteARecipe(id):
    recipeToDelete = session.query(Recipe).filter_by(id=id).one()
    session.delete(recipeToDelete)
    session.commit()
    return 'Removed Recipe with id %s' % id


def get_preview():
    recipes = session.query(Recipe.id, Recipe.title, Recipe.image).all()
    lst = []
    for res in recipes:
        lst.append({'id' : res[0] , 'title': res[1], 'image': res[2]})
    return jsonify(lst)