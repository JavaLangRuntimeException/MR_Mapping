from django.db import models
from django.contrib.auth.models import User

class Room(models.Model):
    name = models.CharField(max_length=255)
    x = models.IntegerField(default=0)
    y = models.IntegerField(default=0)

    def __str__(self):
        return self.name

class Navi(models.Model):
    dep_room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name='navi_dep')
    arr_room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name='navi_arr')
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='rooms', default=1)

    def __str__(self):
        return self.name
