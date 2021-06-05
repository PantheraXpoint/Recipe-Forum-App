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
    return RecipePreview.objects[:lim].only("Name","AvgRating","Img","Level","TotalTime","Id").to_json()

def queryRecipe(id_num):
    if id_num:
        recipe = RecipeDetail.objects(id=id_num)
        # print(recipe[0]["totalView"])
        # recipe.update(totalView=recipe[0]['totalView']+1)
        # try:
        #     prev = RecipePreview.objects(Id=id_num)
        #     prev.update(TotalView=prev[0]["TotalView"]+1)
        # except:
        #     print("preview of this recipe was not found")
        return recipe.only("steps","ingredients","creator","photos","totalLike","avgRating","totalRating","totalView","totalTime","description","name","id").to_json()
    else:
        raise "id was not provided"

def incrementViewCount(id_num):
    recipe = RecipeDetail.objects(id=id_num)
    recipe.update(totalView=recipe[0]['totalView']+1)
    try:
            prev = RecipePreview.objects(Id=id_num)
            prev.update(TotalView=prev[0]["TotalView"]+1)
    except:
        print("preview of this recipe was not found")
    
def deleteRecipe(id_num):
    RecipeDetail.objects(id=id_num).delete()

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