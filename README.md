# Shopify Integration

## Overview

[Shopify](http://www.shopify.com/) is a popular online store service.

This is a fully hosted and supported integration for use with the [Wombat](http://wombat.co) product. With this integration you can perform the following functions:

* Send product information to Shopify whenever products are created or updated.
* Send customer and order information to Shopify whenever orders are created or updated.

## Connection Parameters

The following parameters must be setup within [Wombat](http://wombat.co):

| Name | Value |
| :----| :-----|
| shopify_username | Shopify account username (required) |
| shopify_password | Shopify account password (required) |

## Webhooks

The following webhooks are implemented:

| Name              | Description |
| :-----------------| :-----------|
| get_orders        | Retrieves a list of orders from Shopify with all details of line items, taxes, discounts, shipping charges etc in Wombat official format (based on last updated timestamp). |
| get_products      | Retrieves a list of products from shopify (based on last updated timestamp). |
| get_shipments     | If the order is being fulfilled directly in shopify, a Flow could be setup to call this webhook to get all shipments. |
| get_customers     | Retrieves a list of customers from Shopify (based on last updated timestamp). |

## Wombat

[Wombat](http://wombat.co) allows you to connect to your own custom integrations.  Feel free to modify the source code and host your own version of the integration - or beter yet, help to make the official integration better by submitting a pull request!

![Wombat Logo](http://spreecommerce.com/images/wombat_logo.png)

This integration is 100% open source an licensed under the terms of the New BSD License.
