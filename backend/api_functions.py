import os
from time import time
from json import loads
from flask import Flask, request, Response, jsonify, make_response, send_file
from flask_mongoengine import MongoEngine
from models.RecipeDetail import RecipeDetail
from models.RecipePreview import RecipePreview
from models.Profile import Profile
from bson import ObjectId
from imghdr import what
from werkzeug.security import generate_password_hash, check_password_hash

db = MongoEngine()
#
#   RECIPE FUNCTION
#
def queryBrowse(lim):
    lst = []
    for repc in RecipeDetail.objects[:lim]:
        lst.append( repc.generatePreview() )
    return lst

def queryRecipe(id_num):
    try:
        recipe = RecipeDetail.objects(id=id_num)
        if len(recipe) > 1:
            print('more than one recipe was found with this id')
            raise ''
        recipe.update(totalView=recipe[0]['totalView']+1)
        # return recipe.only("steps","ingredients","creator","photos","totalLike","avgRating","totalRating","totalView","totalTime","description","name","id","_id","TypeID","level").to_json()
        # print(recipe.exclude("_id")[0].getId() )
        return recipe.exclude("_id","url","urlRewrite","hasVideo","hasCooked","hasLiked","servings","totalCook","createdOn")
    except:
        raise "id was not provided"

def incrementViewCount(id_num):
    recipe = RecipeDetail.objects(id=id_num)
    recipe.update(totalView=recipe[0]['totalView']+1)
    
def deleteRecipe(id_num):
    RecipeDetail.objects(id=id_num).delete()

def textSearchPreview(recipe_name, typeid = None):
    if typeid:
        return RecipeDetail.objects(TypeID = typeid).search_text(recipe_name)
    return RecipeDetail.objects.search_text(recipe_name)

def ratePost(user_id, recipe_id, star):
    user = Profile.objects(Id=user_id)
    recipe = RecipeDetail.objects(id=recipe_id)
    if len(recipe) > 1:
        print('more than one recipe was found with this id')
        raise ''
    currentLikeCount = recipe[0]['totalRating']
    recipe.update(
        avgRating= (recipe[0]['avgRating']*currentLikeCount + star) / (currentLikeCount+1),
        totalRating= currentLikeCount+1
        )
    templist = user[0]['HasLikedList']
    templist.append(recipe_id)
    print(templist)
    user.update(
        HasLikedList= templist.append(recipe_id)
    )

#
#   ACCOUNT FUNCTION
#
def queryId(user_id):
    return Profile.objects(Id=user_id)[0]

def queryUsername(username):
    """
    Look up account_detail collection with the username
    returns a list
    """
    return Profile.objects(UserName=username)

def checkinAccount(username,password):
    try:
        acc = Profile.objects(UserName=username)[0]
        hased_pass = acc["PassWord"]
        if check_password_hash(hased_pass, password):
            return acc
        return 0
    except:
        return -1

def queryCreation(username):
    recipe = RecipeDetail.objects(creator__username=username)
    return recipe