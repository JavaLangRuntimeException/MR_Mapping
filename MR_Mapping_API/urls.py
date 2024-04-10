"""MR_Mapping_API URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.urls import path, include
from rest_framework.routers import DefaultRouter
from MR_Mapping_API_app import views
from MR_Mapping_API_app.views import RoomViewSet, NaviViewSet

router = DefaultRouter()
router.register(r'rooms',views.RoomViewSet)
router.register(r'genres', views.NaviViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('rooms/', RoomViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('rooms/<int:pk>/', RoomViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
    path('navi/', NaviViewSet.as_view({'get': 'list', 'post': 'create'})),
    path('navi/<int:pk>/', NaviViewSet.as_view({'get': 'retrieve', 'put': 'update', 'delete': 'destroy'})),
]


