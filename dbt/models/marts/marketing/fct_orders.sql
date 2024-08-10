with
    orders as (
        select *
        from {{ ref('stg_jaffle_shop__orders') }}
    )

    , payments as (
        select *
        from {{ ref('stg_stripe__payment') }}
    )

    , payment_amount as (
        select
            order_id
            , sum(amount) as amount
        from payments
        where payment_status = 'success'
        group by order_id
    )

    , final as (
        select 
            orders.order_id
            , orders.customer_id
            , orders.order_date
            , coalesce(payment_amount.amount, 0) as amount
        from orders
        left join payment_amount
            on orders.order_id = payment_amount.order_id
    )

select *
from final
