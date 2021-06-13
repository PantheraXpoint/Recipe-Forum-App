import os
from time import time
from json import loads
from flask import Flask, request, Response, jsonify, make_response, send_file
from flask_mongoengine import MongoEngine
from models.RecipeDetail import RecipeDetail, IngredientDetail
from models.RecipePreview import RecipePreview
from models.Profile import Profile, Rating
from bson import ObjectId
from imghdr import what
from werkzeug.security import generate_password_hash, check_password_hash
from copy import copy

db = MongoEngine()

#
#   RECIPE FUNCTION
#
def queryBrowse(lim):
    lst = []
    for repc in RecipeDetail.objects[:lim]:
        lst.append( repc.generatePreview() )
    return lst

def getRecipeObject(recipe_id):
    return RecipeDetail.objects(id=recipe_id).first()

def queryRecipe(id_num):
    try:
        recipe = RecipeDetail.objects(id=id_num)
        if len(recipe) > 1:
            print('more than one recipe was found with this id')
            raise ''
        recipe.update(totalView=recipe[0]['totalView']+1)

        return recipe.exclude("url","urlRewrite","hasVideo","hasCooked","hasLiked","servings","totalCook","createdOn")
    except:
        raise "id was not provided"
    # return recipe.only("steps","ingredients","creator","photos","totalLike","avgRating","totalRating","totalView","totalTime","description","name","id","_id","TypeID","level").to_json()
    # print(recipe.exclude("_id")[0].getId() )

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
    templist = copy(user[0]['HasLikedList'])
    templist.append( Rating(recipe_id = recipe_id, rating = star) )
    user.update(
        HasLikedList= templist
    )

def updateRating(user_id, recipe_id, star):
    user = Profile.objects(Id=user_id).first()
    recipe = RecipeDetail.objects(id=recipe_id)
    if len(recipe) > 1:
        print('more than one recipe was found with this id?')
        raise ''
    currentLikeCount = recipe[0]['totalRating']
    
    for entry in user.HasLikedList:
        if entry.recipe_id == recipe_id:
            previousrating = entry.rating
            entry.rating = star

    recipe.update(
        avgRating= (recipe[0]['avgRating']*currentLikeCount - previousrating + star) / (currentLikeCount)
    )
    user.save()

def editRecipeFunc(username, recipe_id, body):
    recipe = RecipeDetail.objects(id=recipe_id)
    rep = RecipeDetail.objects(id=recipe_id).first()
    if recipe:
        if recipe[0].checkCreator( username ):
            # try:
            recipe.update(
                name = body.get("name", rep["name"]),
                description = body.get("description", rep["description"]),
                TypeID = body.get("TypeID", rep["TypeID"]),
                level = body.get("level", rep["level"]),
                totalTime = body.get("totalTime", rep["totalTime"])
            )
            step = body.get("steps")
            photo = body.get("photos")
            ingredient = body.get("ingredients")
            # ingredient_list = []
            # if ingredient:
            #     for ingredi in ingredient:
            #         temp = IngredientDetail(
            #                 name=ingredi["name"],
            #                 quantity=ingredi["quantity"],
            #                 unit=ingredi["unit"]
            #             )
            #         temp.save()
            #         recipe.update(ingredients = rep["ingredients"].append(temp.get()) )
                    # ingredient_list.append( 
                    #     temp.serialize()
                    # )

            if step:
                recipe.update(steps=step)
            if photo:
                recipe.update(photos=photo)
            if ingredient:
                recipe.update(ingredients = ingredient )
                # print(ingredient)
            return 200 #ok
            # except:
            #     return make_response({'status':'Internal server error', 'message' : 'Something wrong happened during editing recipe'},500)
        return 403 #forbidden
    return 404 #not found

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