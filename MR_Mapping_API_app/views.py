from rest_framework import viewsets, permissions
from .models import Room, Navi
from .serializers import RoomSerializer, NaviSerializer, UserSerializer
from django.contrib.auth.models import User
from rest_framework.permissions import IsAuthenticated

class UserViewSet(viewsets.ModelViewSet):
    ermission_classes = [IsAuthenticated]
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.AllowAny]

class RoomViewSet(viewsets.ModelViewSet):
    ermission_classes = [IsAuthenticated]
    queryset = Room.objects.all()
    serializer_class = RoomSerializer
    permission_classes = [permissions.IsAuthenticated]

class NaviViewSet(viewsets.ModelViewSet):
    ermission_classes = [IsAuthenticated]
    queryset = Navi.objects.all()
    serializer_class = NaviSerializer
    permission_classes = [permissions.IsAuthenticated]
