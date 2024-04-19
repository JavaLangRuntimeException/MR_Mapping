from django.urls import path, include
from rest_framework.routers import DefaultRouter
from MR_Mapping_API_app.views import RoomViewSet, NaviViewSet, UserViewSet, LoginViewSet, NaviCreateView
from rest_framework.authtoken import views
from django.contrib import admin

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'rooms', RoomViewSet)
router.register(r'navis', NaviViewSet)
router.register(r'login', LoginViewSet, basename='login')

urlpatterns = [
    path('', include(router.urls)),
    path('admin/', admin.site.urls),
    path('api-token-auth/', views.obtain_auth_token),
    path('navi/create/', NaviCreateView.as_view(), name='navi-create'),
]
