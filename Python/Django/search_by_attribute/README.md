[![Contact me on Codementor!](https://cdn.codementor.io/badges/i_am_a_codementor_dark.svg)](http://links.datata.mx/omar-trejo-codementor)
[![Contact me on HackHands!](https://s31.postimg.org/blm5vo1ob/hackhands.png)](http://links.datata.mx/omar-trejo-hackhands)
[![Send me an email!](https://s31.postimg.org/hqyfsb9ob/email.png)](mailto:otrenav@gmail.com)
[![Follow me on Twitter!](https://s31.postimg.org/ghtgyp157/twitter.png)](http://links.datata.mx/omar-trejo-twitter)
[![Connect with me on LinkedIn](https://s32.postimg.org/nwk9of3qd/linkedin.png)](http://links.datata.mx/omar-trejo-linkedin)
[![Follow me on GitHub!](https://s31.postimg.org/pmn681ezv/github.png)](http://links.datata.mx/omar-trejo-github)

---

# Search by attribute

## Problem

Using [Django REST Framework](http://www.django-rest-framework.org/) to search for a model instance by one of its attributes.

## Solutions

### Initial Django setup

This solutions asssume you have a setup similar to the following:

- Entry point URLs

```
urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^items/', include('items.urls')),
]
```

- Django model

```
class Item(models.Model):

    sku = models.PositiveIntegerField()
    link = models.CharField(max_length=2000)
    brand = models.CharField(max_length=200)
```

- Django REST Framework Basic Serializer

```
class ItemSerializer(serializers.ModelSerializer):

    class Meta:
        model = Item
```

### Using Django URL parameters

If you know the order of the parameters or the queries are simple, this may be a good option for you. This is a more "Pythonic" way of doing it, and it results in less and more simple code.

To search for an instance with its `sku` equal to 10, we would request:

```
http://localhost:8000/items/10/
```

#### Django setup

- URL setup in the `items` app

```
urlpatterns = [
    url('^(?P<sku>.+)/$', viewsets.ItemListUsingURL.as_view())
]
```

- ViewSet for the `Item` model

```
class ItemListUsingURL(generics.ListAPIView):

    serializer_class = serializers.ItemSerializer

    def get_queryset(self):
        requested_sku = self.kwargs['sku']
        return(models.Item.objects.filter(sku=requested_sku))
```

The entry point for the `sku` request parameter is in the URL configuration. If it does not receive such a positional parameter, then it will go into the following URL in the configuration (or give an error if it doesn't find any other possible URLs).

This will return a list of all `Item`s that contain a `sku` equal to the want that is received in the URL request. If more than one `Item` has the same `sku`, then all of them will be returned.

### Using Generic URL parameters

To search for an instance with its `sku` equal to 10, we would request:

```
http://localhost:8000/items/search/?sku=10
```

If you don't know the order of the parameters or the queries are very complex, this may be a good option for you. This is a more general way of doing it, and it results in a more complex but more flexible way of doing it.

#### Django setup

- URL setup in the `items` app

```
urlpatterns = [
    url('^search/', viewsets.ItemListUsingParameters.as_view())
]
```

- ViewSet for the `Item` model

```
class ItemListUsingParameters(views.APIView):

    def get(self, request, **kwargs):
        queryset = models.Item.objects.all()
        requested_sku = self.request.query_params.get('sku', None)
        if requested_sku:
            queryset = queryset.filter(sku=requested_sku)
        return(response.Response(queryset.values()))
        # return(response.Response(queryset.values_list('link', flat=True)[0]))
```

The entry point for the `sku` request parameter is in the second line in the `get()` method. If it doesn't find such an `sku` parameter, it will return all of the `Item`s currently stored.

This will return a list of all `Item`s that contain a `sku` equal to the want that is received in the URL request. If you are certain that `sku` will be unique, you may uncomment the second `return` statement, which will only take the `link` attribute in the model and return the first element in the list (it's a list because it could potentially contain many other objects).
