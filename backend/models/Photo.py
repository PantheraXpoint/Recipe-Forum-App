
import mongoengine_goodjson as gj
from flask_mongoengine import MongoEngine

db = MongoEngine()

class Photo(db.EmbeddedDocument):
    url = db.StringField(required=True)
    height = db.IntField()
    width = db.IntField()
    
    meta = {'collection': 'recipe_detail', 'allow_inheritance': True}
