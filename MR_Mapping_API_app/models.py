from django.db import models


class Room(models.Model):
    name = models.CharField(max_length=255)
    x = models.IntegerField(default=0)
    y = models.IntegerField(default=0)
    def __str__(self):
        return self.name

class Navi(models.Model):
  dep_room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name='navi_dep')
  arr_room = models.ForeignKey(Room, on_delete=models.CASCADE, related_name='navi_arr')

  def __str__(self):
      return self.name
