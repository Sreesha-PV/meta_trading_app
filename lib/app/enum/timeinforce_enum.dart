enum TimeInForce {
    // #[sea_orm(num_value = 0)]
    Unknown ,
    // = 0,

    // #[sea_orm(num_value = 1)]
    GTC, 
    //  = 1, // Good Till Cancelled

    // #[sea_orm(num_value = 2)]
    GTF ,
    // = 2, // Good Till Filled

    // #[sea_orm(num_value = 3)]
    GTD, 
    //  = 3, // Good Till Date

    // #[sea_orm(num_value = 4)]
    GTDT ,
    // = 4, // Good Till Date-Time

    // #[sea_orm(num_value = 5)]
    Day,
    //  = 5, // Day Order

    // #[sea_orm(num_value = 10)]
    Normal,
    //  = 10,

    // #[sea_orm(num_value = 11)]
    FOK ,
    // = 11, // Fill Or Kill

    // #[sea_orm(num_value = 12)]
    // FAK = 12, // Fill And Kill

    // #[sea_orm(num_value = 12)]
    IOC
    //  = 12, // Fill And Kill
}


