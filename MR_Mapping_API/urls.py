from django.urls import path, include
from rest_framework.routers import DefaultRouter
from MR_Mapping_API_app.views import RoomViewSet, NaviViewSet, UserViewSet

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'rooms', RoomViewSet)
router.register(r'navis', NaviViewSet)

urlpatterns = [
    path('', include(router.urls)),
]
