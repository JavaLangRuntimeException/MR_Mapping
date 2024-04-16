from rest_framework import viewsets
from .models import Room, Navi
from .serializers import RoomSerializer, NaviSerializer, UserSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import AllowAny

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [AllowAny]

class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer
    permission_classes = [AllowAny]

class NaviViewSet(viewsets.ModelViewSet):
    queryset = Navi.objects.all()
    serializer_class = NaviSerializer
    permission_classes = [AllowAny]
