# ~movie-bag/database/models.py
import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine

db = MongoEngine()

class Photo(gj.Document):
    url = db.StringField(required=True)
    height = db.IntField()
    weight = db.IntField()
    meta = {'collection': 'recipe_detail', 'allow_inheritance': True}
