# -*- coding: utf-8 -*-

from django.conf.urls import url
from rest_framework import routers
import viewsets


urlpatterns = [
    url('^search/', viewsets.ItemListUsingParameters.as_view()),
    url('^(?P<sku>.+)/$', viewsets.ItemListUsingURL.as_view())
]

router = routers.DefaultRouter()
router.register(r'list', viewsets.ItemViewSet)

urlpatterns = router.urls + urlpatterns
