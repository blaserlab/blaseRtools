# An S4 Image Catalog

This object holds all of the individual Image objects.

Methods are provided for

- viewing as a tibble: ImageCatalog.as_tibble

- writing to tsv format: ImageCatalog.write

- adding an image: ImageCatalog.add

- deleting an image: ImageCatalog.delete

- subsetting and extracting: brackets and double brackets

An ImageCatalog object can be made from a list of Image objects using
ImageCatalog(list = ).

More commonly, you will generate the ImageCatalog from a tsv catalog
file. To make an image catalog this way, run ImageCatalog(catalog_path =
).

## Usage

``` r
# S4 method for class 'ImageCatalog'
show(object)

# S4 method for class 'ImageCatalog,ANY,ANY,ANY'
x[i, j, ..., drop = TRUE]

# S4 method for class 'ImageCatalog,ANY,ANY'
x[[i, j, ..., drop = TRUE]]

# S4 method for class 'ImageCatalog'
x$name

ImageCatalog.as_tibble(image_catalog)

ImageCatalog.write(image_catalog, out)

ImageCatalog.add(image_catalog, image)

ImageCatalog.delete(image_catalog, hash)
```
