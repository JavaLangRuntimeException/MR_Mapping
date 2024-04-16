from rest_framework import viewsets, permissions
from .models import Room, Navi
from .serializers import RoomSerializer, NaviSerializer, UserSerializer
from django.contrib.auth.models import User

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]

class RoomViewSet(viewsets.ModelViewSet):
    queryset = Room.objects.all()
    serializer_class = RoomSerializer
    permission_classes = [permissions.IsAuthenticated]

class NaviViewSet(viewsets.ModelViewSet):
    queryset = Navi.objects.all()
    serializer_class = NaviSerializer
    permission_classes = [permissions.IsAuthenticated]
