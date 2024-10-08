with
    source as (
        select *
        from {{ source('raw_stripe', 'payments') }}
    )

    , renamed as (
        select 
            id as payment_id
            , orderid as order_id
            , paymentmethod as payment_method
            , status as payment_status
            , amount / 100 as amount
            , created as created_at
        from source
    )

select *
from renamed