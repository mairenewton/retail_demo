view: transaction_detail {
  derived_table: {
    explore_source: ndt_explore {
      column: order_id {}
      column: customer_id {}
      column: channel_id {}
      column: gross_margin {}
      column: product_id {}
      column: store_id {}
      column: sale_price {}
      column: transaction_raw {}
      column: latitude { field: stores.latitude }
      column: longitude { field: stores.longitude }
      column: store_name { field: stores.name }
      column: brand { field: products.brand }
      column: category { field: products.category }
      column: department { field: products.department }
      column: product_name { field: products.name }
      column: sku { field: products.sku }
      column: channel_name { field: channels.name }
      column: traffic_source { field: customers.traffic_source }
      column: city { field: customers.city }
      column: country { field: customers.country }
      column: registered_date { field: customers.registered_date }
      column: email { field: customers.email }
      column: first_name { field: customers.first_name }
      column: gender { field: customers.gender }
      column: last_name { field: customers.last_name }
      column: address_latitude { field: customers.latitude }
      column: address_longitude { field: customers.longitude }
      column: state { field: customers.state }
      column: postcode { field: customers.postcode }
    }
  }
  dimension: order_id {type: number}
  dimension: customer_id {type: number hidden: yes}
  dimension: channel_id {type: number hidden: yes}
  dimension: product_id {type: number hidden: yes}
  dimension: store_id {type: number hidden: yes}
  dimension: sale_price {type: number}
  dimension: gross_margin {type: number}
  dimension_group: transaction {
    type: time
    sql: ${TABLE}.transaction_raw ;;
  }
  dimension: latitude {
    view_label: "Store"
    type: number
  }
  dimension: longitude {
    view_label: "Store"
    type: number
  }
  dimension: store_name {view_label: "Store"}
  dimension: brand {view_label: "Product"}  # Optional
  dimension: category {view_label: "Product"}
  dimension: department {view_label: "Product"}  # Optional
  dimension: product_name {view_label: "Product"}
  dimension: sku {view_label: "Product"}  # Optional
  dimension: channel_name {view_label: "Channel"}
  dimension: traffic_source {view_label: "Customer"}  # Optional
  dimension: city {view_label: "Customer"}  # Optional
  dimension: country {view_label: "Customer"}
  dimension_group: registered {
    view_label: "Customer"
    type: time
    timeframes: [raw,date,week,month,year,day_of_week,week_of_year,month_name,quarter,quarter_of_year]
    sql: ${TABLE}.registered_date ;;
  }
  dimension: email {view_label: "Customer"}  # Optional
  dimension: first_name {view_label: "Customer"}  # Optional
  dimension: gender {view_label: "Customer"}  # Optional
  dimension: last_name {view_label: "Customer"}  # Optional
  dimension: address_latitude {
    view_label: "Customer"
    type: number
  }  # Optional
  dimension: address_longitude {
    view_label: "Customer"
    type: number
  }  # Optional
  dimension: state {view_label: "Customer"}  # Optional
  dimension: postcode {
    view_label: "Customer"
    type: zipcode
  }
}
