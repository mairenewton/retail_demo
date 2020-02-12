connection: "lookerdata_bq"

include: "../views/*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

datagroup: daily {
  sql_trigger: SELECT CURRENT_DATE() ;;
  max_cache_age: "24 hours"
}

explore: transaction_detail {

}

explore: ndt_explore {
  from: transactions
  label: "NDT Builder"
  view_label: "Transaction Detail"
#   hidden: yes
  description: "Used for building NDT to partition and pre-join key tables"

  join: customers {
    relationship: many_to_one
    sql_on: ${ndt_explore.customer_id} = ${customers.id} ;;
  }

  join: products {
    relationship: many_to_one
    sql_on: ${products.id} = ${ndt_explore.product_id} ;;
  }

  join: stores {
    type: left_outer
    sql_on: ${stores.id} = ${ndt_explore.store_id} ;;
    relationship: many_to_one
  }

  join: channels {
    type: left_outer
    sql_on: ${channels.id} = ${ndt_explore.channel_id} ;;
    relationship: many_to_one
  }
}
