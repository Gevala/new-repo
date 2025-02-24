from django.urls import path
from .views import health_check, quotes_list

urlpatterns = [
    path('health', health_check, name='health_check'),
    path('quotes', quotes_list, name='quotes_list'),
]
