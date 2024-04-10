from rest_framework import viewsets, serializers
from .models import Room, Navi

class RoomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Room
        fields = '__all__'

class NaviSerializer(serializers.ModelSerializer):
    dep_room = RoomSerializer(read_only=True)
    arr_room = RoomSerializer(read_only=True)

    class Meta:
        model = Navi
        fields = '__all__'

class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer

class NaviViewSet(viewsets.ModelViewSet):
    queryset = Navi.objects.all()
    serializer_class = NaviSerializer
