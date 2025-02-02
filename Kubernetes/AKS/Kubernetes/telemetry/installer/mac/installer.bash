#!/bin/bash

#################################################################################################################################
##################################################### Installer Mac Script ######################################################
#################################################################################################################################

# Load functions
write_log "INFO" "Loading installer functions ..."
source $logzio_temp_dir/installer_functions.bash

# Get general params
execute_task "get_general_params" "getting general params"

# Get the selected products
execute_task "get_selected_products" "getting the selected products"

# Build tolerations helm sets
execute_task "build_tolerations_helm_sets" "building tolerations Helm sets"

# Get environment ID
execute_task "get_environment_id" "getting environment ID"

# Build enable metrics or traces helm set
if $is_metrics_option_selected || $is_traces_option_selected; then
    execute_task "build_enable_metrics_or_traces_helm_set" "building enable metrics or traces Helm set"
fi

# Build metrics/traces environment tag helm set
if $is_metrics_option_selected || $is_traces_option_selected; then
    execute_task "build_environment_tag_helm_set" "building metrics/traces environment tag Helm set"
fi

# Build metrics/traces environment ID helm set
if $is_metrics_option_selected || $is_traces_option_selected; then
    execute_task "build_environment_id_helm_set" "building metrics/traces environment ID Helm set"
fi

# Get logs scripts
if $is_logs_option_selected; then
    execute_task "get_logs_scripts" "getting logs scripts"
fi

# Get metrics scripts
if $is_metrics_option_selected; then
    execute_task "get_metrics_scripts" "getting metrics scripts"
fi

# Get traces scripts
if $is_traces_option_selected; then
    execute_task "get_traces_scripts" "getting traces scripts"
fi

# Run logs script
if $is_logs_option_selected; then
    write_log "INFO" "Running logs script ..."
    echo -e "\nlogs:"
    source $logzio_temp_dir/logs.bash
fi

# Run metrics script
if $is_metrics_option_selected; then
    write_log "INFO" "Running metrics script ..."
    echo -e "\nmetrics:"
    source $logzio_temp_dir/metrics.bash
fi

# Run traces script
if $is_traces_option_selected; then
    write_log "INFO" "Running traces script ..."
    echo -e "\ntraces:"
    source $logzio_temp_dir/traces.bash
fi

# Run Helm install
echo -e "\ninstaller:"
execute_task "run_helm_install" "running Helm install"

# Get postrequisites scripts
execute_task "get_postrequisites_scripts" "getting postrequisites scripts"

# Run postrequisites script
write_log "INFO" "Running postrequisites script ..."
echo -e "\npostrequisites:"
source $logzio_temp_dir/postrequisites.bash

if ! $are_all_pods_running_or_completed; then
    if $is_any_pod_pending || $is_any_pod_failed; then
        # Print fail message
        echo
        print_error "##### Logz.io agent failed #####"
    else
        # Print success message
        echo
        print_info "##### Logz.io agent was finished successfully #####"
    fi
else
    # Print success message
    echo
    print_info "##### Logz.io agent was finished successfully #####"
fi

# Print information
echo -e "\nInformation:\n"
echo -e "\033[0;35mShow Helm Install Command\033[0;37m: sudo cat $PWD/logzio.helm"
