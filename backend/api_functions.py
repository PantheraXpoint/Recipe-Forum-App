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
import pymongo

db = MongoEngine()
#
#   RECIPE FUNCTION
#
def queryBrowse(lim):
    return RecipePreview.objects[:lim].only("Name","AvgRating","Img","Level","TotalTime","Id").to_json()

def queryRecipe(id_num):
    if id_num:
        return RecipeDetail.objects(id=id_num).only("steps","ingredients","photos","totalLike","avgRating","totalRating","totalTime","description","name").to_json()
    else:
        return RecipeDetail.objects.only("steps","ingredients","photos","totalLike","avgRating","totalRating","totalTime","description","name").to_json()

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
        # print( Profile(**deats) )
        hased_pass = acc["PassWord"]
        if check_password_hash(hased_pass, password):
            return acc
        return 0
    except:
        return -1