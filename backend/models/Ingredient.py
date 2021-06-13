# ~movie-bag/database/models.py
import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine

db = MongoEngine()

class Unit(db.EmbeddedDocument):
    value = db.StringField(required=True)
    unit = db.StringField(required=True)

class Ingredient(db.EmbeddedDocument):
    name = db.StringField(required=True)
    unit = db.EmbeddedDocumentField(Unit)
    meta = {'collection': 'recipe_detail', 'allow_inheritance': True}
