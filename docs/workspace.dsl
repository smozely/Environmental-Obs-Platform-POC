workspace "Environmental Observations" "POC for Environmental Observations" {

    model {

        field_collector = person "Field Collector" "User who is taking Observations / Samples in the field" "Council Staff" 
        field_devices = softwareSystem "Telemetry Devices" "Council Managed Telemetry capturing devices. e.g. River Guages, Rainfall Meters, Air Quality Sensors" "Existing System"
        field_capture_apps = softwareSystem "Field Capture Tools" "Field tools used by Council staff to capture Observations. e.g. Water Quality Samples, Ecosystem health survey" "Mobile App"

        sample_processing_labs = softwareSystem "Processing Labs" "Laboratories that processes field samples" "Existing System"

        external_data_feeds = softwareSystem "External Data Feeds" "Third party data being pushed e.g. Consent Holder Water Abstraction Information, Citizen Science" "Generic System"
        external_data_stores = softwareSystem "External Data Sources" "Third party data which can be pulled e.g. Metservice coded data" "Generic System"
        
        external_data_client_push = softwaresystem "External Data Stores" "External systems where data is pushed to. e.g. LAWA, Core-16" "Generic System"
        external_data_client_pull = softwaresystem "External Data Clients" "External systems that pull data. e.g. Application Developers, Engineering Firms, NIWA" "Generic System"

        enterprise = enterprise "Council"  {
            hydrotel = softwaresystem "Hydrotel System" "Hydrotel where Telemetry data lands first." "Existing System"
            internal_capture_systems = softwaresystem "Internal Data Capture Systems" "Other council tools which are capturing data. e.g. KiECO, Access Databases" "Existing System"
            manager = person "Observations custodian" "User who is a custodian of Observation data. Can QA observations" "Council Staff" 

            core = group "EDMS" {                
                eom = softwareSystem "Aquisition and Management" "Where new Observations are landed and QA processes done. Transactional side of managing data e.g. Managing which Telemetry data requires QA, and tools to apply quality codind"
                eoa = softwareSystem "Analytics and Export" "Where Observational data is stored and exposed for analytical queries. e.g. Daily statistics"                
            }            
            
            eop = softwareSystem "Event Driven Analysis / Alerting" "Where Observational data is processed to created derived Observations, trigger automated QA processes or alerting based on data anomalies. Event driven or batch. e.g. Gaugings to Flow, Naturalized flows, Data anomalies identified"

            geo_network = softwareSystem "Geospatial Network" "Model of sampling sites and their relationship to catchments, territories, citys"
            regional_plan = softwareSystem "Digitised Regional Plan" "Model of the regional plan to allow comparsion between environmental observations and plan outcomes"
            resource_consents = softwareSystem "IRIS - Resource Consents" "Model of the resource consents and the limits that can be compared with observations" "Existing System"

            group "Emergency Monitoring" {
                softwareSystem "Flood Prediction" "Viewer for flood likleyhood in a given area, based off long term environmental observations" "Web App"
                softwareSystem "Flood Event Monitoring" "Viewer for current state in a severe weather event, based off real time data" "Mobile App"                
            }

            group "Consenting" {
                allocations = softwareSystem "Allocations" "Viewer for how much resource has been allocated via consents vs the regional plan goals" "Web App"                
            }

            group "Compliance" {
                cc = softwareSystem "Compliance Checking" "Viewer to allow compliance officers view behaviour of consent holders vs resource consent conditions" "Web App"
                ca = softwareSystem "Compliance Alerting" "Alerting application to help compliance officers manage when consent holders have broken resource consent conditions" "Web App"
            }

            group "Planning" {
                pl = softwareSystem "Plan vs Limits" "Viewer for how limit / targets set out int he regional plan are being met" "Web App"                
            }

            group "Public" {
                public_facing_web_site = softwareSystem "Council public Website" "Council website with Environmental data. e.g. Flow Viewers, Water Quality Reporting, Plan vs Limits." "Web App"
            }

            # internal_reporting_systems = softwareSystem "Data reporting systems. e.g. GIS Viewers, Power BI Reports" 
            # internal_monitoring_systems = softwareSystem "Systems for monitoring live situation. e.g. Flood Monitoring, Civil Defence Alerting" 
            # internal_business_process_systems = softwareSystem "Internal data reporting systems. e.g. GIS Viewers, Power BI Reports" 
            # other_business_data_store = softwareSystem "Systems that manage other counci; data that is merged with Observations as part of business process. e.g. Consents mathed with water use" "Existing System"
        }
    
        field_devices -> hydrotel "Sending latest Observations to"

        field_collector -> field_capture_apps "Captures Observations in"
        field_collector -> sample_processing_labs "Sends samples to"
        field_capture_apps -> eom "Send field captured Observations to"
        sample_processing_labs -> eom "Send processed sample Observations to"
        
        hydrotel -> eom "Sends latest data to"
        internal_capture_systems -> eom "Sends latest data to"
        external_data_feeds -> eom "Sends latest data to"
        external_data_stores -> eom "Data pulled from"
        
        manager -> eom "Reviews telemetry data and marks as QA'ed"
        
        eom -> eoa "Replicates data to"
        eom -> eop "Pushes new data events to"
        eoa -> eop "Reads data from"
        eop -> eom "Pushes derived Observations to"
    
        eoa -> external_data_client_push "Sends data to"
        eoa -> external_data_client_pull "Pull data from"

        eoa -> public_facing_web_site "Sends data to"
        eom -> public_facing_web_site "Sends live data to"

        resource_consents -> allocations "Pulls consented amounts as allocated"
        regional_plan -> allocations "Pulls planned allocation limits"

        resource_consents -> eop "Pulls resource consent information for triggering alerts"
        eop -> ca "Publishes compliance alerts to"
        eoa -> cc "Pulls environmental Observations for comparsion"
        resource_consents -> cc "Pulls resource consent information for comparsion"

        eoa -> pl "Pulls observations for comparsion limits"
        regional_plan -> pl "Provides the limit information for comparsion"
        geo_network -> pl "Provides boundary information for viewing limits by area"

        # eom -> internal_monitoring_systems "Pushes latest data to"
        
        # eoa -> internal_business_process_systems "Sends data to"
        # eom -> internal_business_process_systems "Sends live data to"
        # other_business_data_store -> internal_business_process_systems "Sends non-Environment data to"
    }
    
    views {
        systemLandscape "SystemLandscape" "Overview" {
            include *
        }
        
        styles {
            element "Person" {
                color #ffffff
                background #999999
                fontSize 22
                shape Person
            }
            
            element "Council Staff" {
                background #08427b
            }
            
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Generic System" {
                background #FFB6C1
                color #ffffff
            }

            element "Web App" {
                shape WebBrowser
                background #FF9900
                color #ffffff
            }

            element "Mobile App" {
                background #FF9900
                color #ffffff
                shape MobileDeviceLandscape
            }
            
        }
    }

}
