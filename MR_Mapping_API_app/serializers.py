from rest_framework import serializers
from .models import Room, Navi

# Room serializer
class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = '__all__'  # Serialize all fields

# Navi serializer
class NaviSerializer(serializers.ModelSerializer):
    # Since it's a foreign key, we need to provide a representation for the rooms
    dep_room = RoomSerializer(read_only=True)
    arr_room = RoomSerializer(read_only=True)

    class Meta:
        model = Navi
        fields = '__all__'
