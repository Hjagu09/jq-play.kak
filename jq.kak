provide-module jq %{
	# buffer to read data from
	declare-option -hidden str jq_source_buf ""
	# the filter
	declare-option -hidden str jq_filter     ""

	# clean up after us
	define-command jq-stop %{
		remove-hooks global jq
		set global jq_source_buf ""
		try %{
			delete-buffer jq_filter
			delete-buffer jq_out
		}
	}

	# start jq-play
	define-command jq-start %{
		# clear anythin that was here before
		jq-stop

		# current buffer as source
		set global jq_source_buf %val{bufname}

		# setup filter buffer
		edit -scratch jq_filter
		execute-keys "i.<esc>"

		hook -group jq buffer NormalIdle .* %{
			jq-run
		}
		hook -group jq buffer InsertIdle .* %{
			jq-run
		}

		# setup output buffer
		edit -scratch jq_out
		set buffer filetype json
		buffer %opt{jq_source_buf}

		hook -group jq buffer NormalIdle .* %{
			jq-run
		}
		hook -group jq buffer InsertIdle .* %{
			jq-run
		}

		# run jq
		jq-run
	}

	# run jq. This is executed in hooks
	define-command -hidden jq-run %{
		# set jq_filter with the contents of the jq_filter buffer
		execute-keys -draft %{:b jq_filter<ret>%Hy:set global jq_filter %val{reg_"}<ret>}
		# copy the source buffer into the output buffer and run
		# jq over it
		execute-keys -draft %exp{:e %opt{jq_source_buf}<ret>%%y:b jq_out<ret>%%R|jq %opt{jq_filter}<ret>}
	}
}
