# -*- coding: utf-8 -*-

from rest_framework import generics, viewsets, views, response

from . import models
from . import serializers


class ItemViewSet(viewsets.ModelViewSet):

    queryset = models.Item.objects.all()
    serializer_class = serializers.ItemSerializer


class ItemListUsingURL(generics.ListAPIView):

    serializer_class = serializers.ItemSerializer

    def get_queryset(self):
        requested_sku = self.kwargs['sku']
        return(models.Item.objects.filter(sku=requested_sku))


class ItemListUsingParameters(views.APIView):

    def get(self, request, **kwargs):
        queryset = models.Item.objects.all()
        requested_sku = self.request.query_params.get('sku', None)
        if requested_sku:
            queryset = queryset.filter(sku=requested_sku)
        # return(response.Response(queryset.values()))
        return(response.Response(queryset.values_list('link', flat=True)[0]))
