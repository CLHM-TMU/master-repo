#!/usr/bin/env bash

_qiime_completion()
{
  local COMP_WORDS=(${COMP_WORDS[*]})
  local incomplete
  if [[ ${COMP_CWORD} -lt 0 ]] ; then
    COMP_CWORD="${#COMP_WORDS[*]}"
    incomplete=""
  else
    incomplete="${COMP_WORDS[COMP_CWORD]}"
  fi

  local curpos nextpos nextword
  nextpos=0

  curpos=${nextpos}
  while :
  do
    nextpos=$((curpos + 1))
    nextword="${COMP_WORDS[nextpos]}"
    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
      if [[ ${incomplete} == -* ]] ; then
        echo "$(compgen -W "--help --version" -- $incomplete)"
      else
        echo "$(compgen -W "info tools dev alignment boots composition cutadapt dada2 deblur demux diversity diversity-lib emperor feature-classifier feature-table fondue fragment-insertion kmerizer longitudinal metadata phylogeny quality-control quality-filter rescript sample-classifier stats taxa types vizard vsearch" -- $incomplete)"
      fi
      return 0
    else
      case "${nextword}" in
        info)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --config-level" -- $incomplete)"
              else
                echo "$(compgen -W "" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        tools)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help" -- $incomplete)"
              else
                echo "$(compgen -W "annotation-create annotation-fetch annotation-list annotation-remove cache-create cache-export cache-fetch cache-garbage-collection cache-import cache-remove cache-status cache-store cast-metadata citations export extract import inspect-metadata list-formats list-types make-report peek replay-citations replay-provenance replay-supplement signature-verify validate view" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                annotation-create)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --annotation-type --name --text --file --fingerprint --output-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                annotation-fetch)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --name --verbose --no-verbose" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                annotation-list)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                annotation-remove)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --name --output-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-create)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-export)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache --key --output-path --output-format" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-fetch)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache --key --output-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-garbage-collection)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-import)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --type --input-path --cache --key --input-format --validate-level" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-remove)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache --key" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-status)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cache-store)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cache --artifact-path --key" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cast-metadata)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --cast --ignore-extra --error-on-missing --output-file" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                citations)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                export)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --output-path --output-format" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                extract)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --output-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                import)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --type --input-path --output-path --input-format --validate-level" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                inspect-metadata)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --tsv --no-tsv" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                list-formats)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --importable --exportable --strict --tsv" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                list-types)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --strict --tsv" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                make-report)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --report-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                peek)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --tsv --no-tsv" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                replay-citations)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --in-fp --recurse --no-recurse --deduplicate --no-deduplicate --suppress-header --no-suppress-header --verbose --no-verbose --out-fp" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                replay-provenance)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --in-fp --recurse --no-recurse --usage-driver --validate-checksums --no-validate-checksums --parse-metadata --no-parse-metadata --use-recorded-metadata --no-use-recorded-metadata --suppress-header --no-suppress-header --verbose --no-verbose --dump-recorded-metadata --no-dump-recorded-metadata --metadata-out-dir --out-fp" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                replay-supplement)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --in-fp --recurse --no-recurse --deduplicate --no-deduplicate --validate-checksums --no-validate-checksums --parse-metadata --no-parse-metadata --use-recorded-metadata --no-use-recorded-metadata --suppress-header --no-suppress-header --verbose --no-verbose --dump-recorded-metadata --no-dump-recorded-metadata --out-fp" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                signature-verify)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --input-path --name" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                validate)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --level" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                view)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --port --verbose" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        dev)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help" -- $incomplete)"
              else
                echo "$(compgen -W "assert-result-data assert-result-type export-default-theme import-theme refresh-cache reset-theme" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                assert-result-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --zip-data-path --expression" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                assert-result-type)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --qiime-type" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                export-default-theme)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --output-path" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                import-theme)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --theme" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                refresh-cache)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                reset-theme)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --yes" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        alignment)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "mafft mafft-add mask" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                mafft)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-n-threads --p-parttree --p-no-parttree --p-large --p-no-large --o-alignment --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                mafft-add)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --i-sequences --p-n-threads --p-parttree --p-no-parttree --p-addfragments --p-no-addfragments --p-keeplength --p-no-keeplength --p-large --p-no-large --o-expanded-alignment --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                mask)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-max-gap-frequency --p-min-conservation --o-masked-alignment --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        boots)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "alpha alpha-average alpha-collection beta beta-average beta-collection core-metrics kmer-diversity resample" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                alpha)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-sampling-depth --p-metric --p-n --p-replacement --p-no-replacement --p-average-method --o-average-alpha-diversity --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-average)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --p-average-method --o-average-alpha-diversity --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-collection)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-sampling-depth --p-metric --p-n --p-replacement --p-no-replacement --o-alpha-diversities --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --p-sampling-depth --p-n --p-replacement --p-no-replacement --p-average-method --p-bypass-tips --p-no-bypass-tips --p-pseudocount --p-alpha --p-variance-adjusted --p-no-variance-adjusted --o-average-distance-matrix --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-average)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --p-average-method --o-average-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-collection)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --p-sampling-depth --p-n --p-replacement --p-no-replacement --p-bypass-tips --p-no-bypass-tips --p-pseudocount --p-alpha --p-variance-adjusted --p-no-variance-adjusted --o-distance-matrices --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                core-metrics)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-sampling-depth --m-metadata-file --p-n --p-replacement --p-no-replacement --p-alpha-average-method --p-beta-average-method --p-pc-dimensions --p-color-by --o-resampled-tables --o-alpha-diversities --o-distance-matrices --o-pcoas --o-emperor-plots --o-scatter-plot --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                kmer-diversity)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-sequences --p-sampling-depth --m-metadata-file --p-n --p-replacement --p-no-replacement --p-kmer-size --p-tfidf --p-no-tfidf --p-max-df --p-min-df --p-max-features --p-alpha-average-method --p-beta-average-method --p-pc-dimensions --p-color-by --p-norm --p-alpha-metrics --p-beta-metrics --o-resampled-tables --o-kmer-tables --o-alpha-diversities --o-distance-matrices --o-pcoas --o-scatter-plot --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                resample)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-sampling-depth --p-n --p-replacement --p-no-replacement --o-resampled-tables --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        composition)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "add-pseudocount ancom ancombc ancombc2 ancombc2-visualizer da-barplot tabulate" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                add-pseudocount)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-pseudocount --o-composition-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                ancom)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-transform-function --p-difference-function --p-filter-missing --p-no-filter-missing --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                ancombc)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-formula --p-p-adj-method --p-prv-cut --p-lib-cut --p-reference-levels --p-tol --p-max-iter --p-conserve --p-no-conserve --p-alpha --o-differentials --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                ancombc2)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-fixed-effects-formula --p-random-effects-formula --p-reference-levels --p-p-adjust-method --p-prevalence-cutoff --p-group --p-structural-zeros --p-no-structural-zeros --p-asymptotic-cutoff --p-no-asymptotic-cutoff --p-alpha --p-num-processes --o-ancombc2-output --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                ancombc2-visualizer)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --i-taxonomy --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                da-barplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --p-effect-size-label --p-feature-id-label --p-error-label --p-significance-label --p-significance-threshold --p-effect-size-threshold --m-feature-ids-file --p-level-delimiter --p-label-limit --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        cutadapt)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "demux-paired demux-single trim-paired trim-single" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                demux-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-seqs --m-forward-barcodes-file --m-forward-barcodes-column --m-reverse-barcodes-file --m-reverse-barcodes-column --p-forward-cut --p-reverse-cut --p-anchor-forward-barcode --p-no-anchor-forward-barcode --p-anchor-reverse-barcode --p-no-anchor-reverse-barcode --p-error-rate --p-batch-size --p-minimum-length --p-mixed-orientation --p-no-mixed-orientation --p-cores --o-per-sample-sequences --o-untrimmed-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                demux-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-seqs --m-barcodes-file --m-barcodes-column --p-cut --p-anchor-barcode --p-no-anchor-barcode --p-error-rate --p-batch-size --p-minimum-length --p-cores --o-per-sample-sequences --o-untrimmed-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                trim-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-sequences --p-adapter-f --p-front-f --p-anywhere-f --p-adapter-r --p-front-r --p-anywhere-r --p-forward-cut --p-reverse-cut --p-error-rate --p-indels --p-no-indels --p-times --p-overlap --p-match-read-wildcards --p-no-match-read-wildcards --p-match-adapter-wildcards --p-no-match-adapter-wildcards --p-minimum-length --p-discard-untrimmed --p-no-discard-untrimmed --p-max-expected-errors --p-max-n --p-quality-cutoff-5end --p-quality-cutoff-3end --p-quality-base --p-cores --o-trimmed-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                trim-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-sequences --p-adapter --p-front --p-anywhere --p-cut --p-error-rate --p-indels --p-no-indels --p-times --p-overlap --p-match-read-wildcards --p-no-match-read-wildcards --p-match-adapter-wildcards --p-no-match-adapter-wildcards --p-minimum-length --p-discard-untrimmed --p-no-discard-untrimmed --p-max-expected-errors --p-max-n --p-quality-cutoff-5end --p-quality-cutoff-3end --p-quality-base --p-cores --o-trimmed-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        dada2)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "denoise-ccs denoise-paired denoise-pyro denoise-single plot-base-transitions" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                denoise-ccs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-front --p-adapter --p-max-mismatch --p-indels --p-no-indels --p-trunc-len --p-trim-left --p-max-ee --p-trunc-q --p-min-len --p-max-len --p-pooling-method --p-chimera-method --p-min-fold-parent-over-abundance --p-allow-one-off --p-no-allow-one-off --p-n-threads --p-n-reads-learn --p-hashed-feature-ids --p-no-hashed-feature-ids --p-retain-all-samples --p-no-retain-all-samples --o-table --o-representative-sequences --o-denoising-stats --o-base-transition-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                denoise-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-trunc-len-f --p-trunc-len-r --p-trim-left-f --p-trim-left-r --p-max-ee-f --p-max-ee-r --p-trunc-q --p-min-overlap --p-max-merge-mismatch --p-trim-overhang --p-no-trim-overhang --p-pooling-method --p-chimera-method --p-min-fold-parent-over-abundance --p-allow-one-off --p-no-allow-one-off --p-n-threads --p-n-reads-learn --p-hashed-feature-ids --p-no-hashed-feature-ids --p-retain-all-samples --p-no-retain-all-samples --o-table --o-representative-sequences --o-denoising-stats --o-base-transition-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                denoise-pyro)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-trunc-len --p-trim-left --p-max-ee --p-trunc-q --p-max-len --p-pooling-method --p-chimera-method --p-min-fold-parent-over-abundance --p-allow-one-off --p-no-allow-one-off --p-n-threads --p-n-reads-learn --p-hashed-feature-ids --p-no-hashed-feature-ids --p-retain-all-samples --p-no-retain-all-samples --o-table --o-representative-sequences --o-denoising-stats --o-base-transition-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                denoise-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-trunc-len --p-trim-left --p-max-ee --p-trunc-q --p-pooling-method --p-chimera-method --p-min-fold-parent-over-abundance --p-allow-one-off --p-no-allow-one-off --p-n-threads --p-n-reads-learn --p-hashed-feature-ids --p-no-hashed-feature-ids --p-retain-all-samples --p-no-retain-all-samples --o-table --o-representative-sequences --o-denoising-stats --o-base-transition-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                plot-base-transitions)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-base-transition-stats --p-nominalq --p-no-nominalq --p-error-in --p-no-error-in --p-error-out --p-no-error-out --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        deblur)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "denoise-16S denoise-other visualize-stats" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                denoise-16S)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-trim-length --p-left-trim-len --p-sample-stats --p-no-sample-stats --p-mean-error --p-indel-prob --p-indel-max --p-min-reads --p-min-size --p-jobs-to-start --p-hashed-feature-ids --p-no-hashed-feature-ids --o-table --o-representative-sequences --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                denoise-other)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --i-reference-seqs --p-trim-length --p-left-trim-len --p-sample-stats --p-no-sample-stats --p-mean-error --p-indel-prob --p-indel-max --p-min-reads --p-min-size --p-jobs-to-start --p-hashed-feature-ids --p-no-hashed-feature-ids --o-table --o-representative-sequences --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                visualize-stats)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-deblur-stats --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        demux)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "emp-paired emp-single filter-samples partition-samples-paired partition-samples-single subsample-paired subsample-single summarize tabulate-read-counts" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                emp-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-seqs --m-barcodes-file --m-barcodes-column --p-golay-error-correction --p-no-golay-error-correction --p-rev-comp-barcodes --p-no-rev-comp-barcodes --p-rev-comp-mapping-barcodes --p-no-rev-comp-mapping-barcodes --p-ignore-description-mismatch --p-no-ignore-description-mismatch --o-per-sample-sequences --o-error-correction-details --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                emp-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-seqs --m-barcodes-file --m-barcodes-column --p-golay-error-correction --p-no-golay-error-correction --p-rev-comp-barcodes --p-no-rev-comp-barcodes --p-rev-comp-mapping-barcodes --p-no-rev-comp-mapping-barcodes --p-ignore-description-mismatch --p-no-ignore-description-mismatch --o-per-sample-sequences --o-error-correction-details --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-samples)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --p-remove-empty --p-no-remove-empty --o-filtered-demux --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-samples-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --p-num-partitions --o-partitioned-demux --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-samples-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --p-num-partitions --o-partitioned-demux --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                subsample-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-fraction --p-drop-empty --p-no-drop-empty --o-subsampled-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                subsample-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-fraction --p-drop-empty --p-no-drop-empty --o-subsampled-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                summarize)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --p-n --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate-read-counts)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --o-counts --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        diversity)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "adonis alpha alpha-correlation alpha-group-significance alpha-phylogenetic alpha-rarefaction beta beta-correlation beta-group-significance beta-phylogenetic beta-rarefaction bioenv core-metrics core-metrics-phylogenetic filter-alpha-diversity filter-distance-matrix mantel partial-procrustes pcoa pcoa-biplot procrustes-analysis tsne umap" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                adonis)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --p-formula --p-permutations --p-n-jobs --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-metric --o-alpha-diversity --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-correlation)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alpha-diversity --m-metadata-file --p-method --p-intersect-ids --p-no-intersect-ids --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-group-significance)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alpha-diversity --m-metadata-file --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-phylogenetic)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --o-alpha-diversity --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                alpha-rarefaction)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-max-depth --p-metrics --m-metadata-file --p-min-depth --p-steps --p-iterations --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-metric --p-pseudocount --p-n-jobs --o-distance-matrix --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-correlation)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --m-metadata-column --p-method --p-permutations --p-intersect-ids --p-no-intersect-ids --p-label1 --p-label2 --o-metadata-distance-matrix --o-mantel-scatter-visualization --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-group-significance)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --m-metadata-column --p-method --p-pairwise --p-no-pairwise --p-permutations --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-phylogenetic)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --p-threads --p-variance-adjusted --p-no-variance-adjusted --p-alpha --p-bypass-tips --p-no-bypass-tips --o-distance-matrix --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-rarefaction)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --p-clustering-method --m-metadata-file --p-sampling-depth --p-iterations --p-correlation-method --p-color-scheme --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                bioenv)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                core-metrics)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-sampling-depth --m-metadata-file --p-with-replacement --p-no-with-replacement --p-n-jobs --p-ignore-missing-samples --p-no-ignore-missing-samples --o-rarefied-table --o-observed-features-vector --o-shannon-vector --o-evenness-vector --o-jaccard-distance-matrix --o-bray-curtis-distance-matrix --o-jaccard-pcoa-results --o-bray-curtis-pcoa-results --o-jaccard-emperor --o-bray-curtis-emperor --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                core-metrics-phylogenetic)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-sampling-depth --m-metadata-file --p-with-replacement --p-no-with-replacement --p-n-jobs-or-threads --p-ignore-missing-samples --p-no-ignore-missing-samples --o-rarefied-table --o-faith-pd-vector --o-observed-features-vector --o-shannon-vector --o-evenness-vector --o-unweighted-unifrac-distance-matrix --o-weighted-unifrac-distance-matrix --o-jaccard-distance-matrix --o-bray-curtis-distance-matrix --o-unweighted-unifrac-pcoa-results --o-weighted-unifrac-pcoa-results --o-jaccard-pcoa-results --o-bray-curtis-pcoa-results --o-unweighted-unifrac-emperor --o-weighted-unifrac-emperor --o-jaccard-emperor --o-bray-curtis-emperor --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-alpha-diversity)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alpha-diversity --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --o-filtered-alpha-diversity --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-distance-matrix)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --o-filtered-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                mantel)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-dm1 --i-dm2 --p-method --p-permutations --p-intersect-ids --p-no-intersect-ids --p-label1 --p-label2 --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partial-procrustes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reference --i-other --m-pairing-file --m-pairing-column --p-dimensions --o-transformed --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                pcoa)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --p-number-of-dimensions --o-pcoa --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                pcoa-biplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-pcoa --i-features --o-biplot --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                procrustes-analysis)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reference --i-other --p-dimensions --p-permutations --o-transformed-reference --o-transformed-other --o-disparity-results --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tsne)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --p-number-of-dimensions --p-perplexity --p-n-iter --p-learning-rate --p-early-exaggeration --p-random-state --o-tsne --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                umap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --p-number-of-dimensions --p-n-neighbors --p-min-dist --p-random-state --o-umap --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        diversity-lib)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "alpha-passthrough beta-passthrough beta-phylogenetic-meta-passthrough beta-phylogenetic-passthrough bray-curtis faith-pd jaccard observed-features pielou-evenness shannon-entropy unweighted-unifrac weighted-unifrac" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                alpha-passthrough)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-metric --o-vector --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-passthrough)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-metric --p-pseudocount --p-n-jobs --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-phylogenetic-meta-passthrough)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-tables --i-phylogenies --p-metric --p-threads --p-variance-adjusted --p-no-variance-adjusted --p-alpha --p-bypass-tips --p-no-bypass-tips --p-weights --p-consolidation --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                beta-phylogenetic-passthrough)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-metric --p-threads --p-variance-adjusted --p-no-variance-adjusted --p-alpha --p-bypass-tips --p-no-bypass-tips --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                bray-curtis)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-n-jobs --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                faith-pd)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-threads --o-vector --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                jaccard)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-n-jobs --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                observed-features)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-vector --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                pielou-evenness)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-drop-undefined-samples --p-no-drop-undefined-samples --o-vector --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                shannon-entropy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-drop-undefined-samples --p-no-drop-undefined-samples --p-base --o-vector --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                unweighted-unifrac)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-threads --p-bypass-tips --p-no-bypass-tips --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                weighted-unifrac)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-phylogeny --p-threads --p-bypass-tips --p-no-bypass-tips --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        emperor)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "biplot plot procrustes-plot" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                biplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-biplot --m-sample-metadata-file --m-feature-metadata-file --p-ignore-missing-samples --p-no-ignore-missing-samples --p-invert --p-no-invert --p-number-of-features --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                plot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-pcoa --m-metadata-file --p-custom-axes --p-ignore-missing-samples --p-no-ignore-missing-samples --p-ignore-pcoa-features --p-no-ignore-pcoa-features --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                procrustes-plot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reference-pcoa --i-other-pcoa --i-m2-stats --m-metadata-file --p-custom-axes --p-ignore-missing-samples --p-no-ignore-missing-samples --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        feature-classifier)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "blast classify-consensus-blast classify-consensus-vsearch classify-hybrid-vsearch-sklearn classify-sklearn extract-reads find-consensus-annotation fit-classifier-naive-bayes fit-classifier-sklearn makeblastdb vsearch-global" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                blast)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query --i-reference-reads --i-blastdb --p-maxaccepts --p-perc-identity --p-query-cov --p-strand --p-evalue --p-output-no-hits --p-no-output-no-hits --p-num-threads --o-search-results --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-consensus-blast)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query --i-reference-taxonomy --i-blastdb --i-reference-reads --p-maxaccepts --p-perc-identity --p-query-cov --p-strand --p-evalue --p-output-no-hits --p-no-output-no-hits --p-min-consensus --p-unassignable-label --p-num-threads --o-classification --o-search-results --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-consensus-vsearch)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query --i-reference-reads --i-reference-taxonomy --p-maxaccepts --p-perc-identity --p-query-cov --p-strand --p-search-exact --p-no-search-exact --p-top-hits-only --p-no-top-hits-only --p-maxhits --p-maxrejects --p-output-no-hits --p-no-output-no-hits --p-weak-id --p-threads --p-min-consensus --p-unassignable-label --o-classification --o-search-results --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-hybrid-vsearch-sklearn)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query --i-reference-reads --i-reference-taxonomy --i-classifier --p-maxaccepts --p-perc-identity --p-query-cov --p-strand --p-min-consensus --p-maxhits --p-maxrejects --p-reads-per-batch --p-confidence --p-read-orientation --p-threads --p-prefilter --p-no-prefilter --p-sample-size --p-randseed --o-classification --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-sklearn)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reads --i-classifier --p-reads-per-batch --p-n-jobs --p-pre-dispatch --p-confidence --p-read-orientation --o-classification --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                extract-reads)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-f-primer --p-r-primer --p-trim-right --p-trunc-len --p-trim-left --p-identity --p-min-length --p-max-length --p-n-jobs --p-batch-size --p-read-orientation --o-reads --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                find-consensus-annotation)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-search-results --i-reference-taxonomy --p-min-consensus --p-unassignable-label --o-consensus-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fit-classifier-naive-bayes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reference-reads --i-reference-taxonomy --i-class-weight --p-classify--alpha --p-classify--chunk-size --p-classify--class-prior --p-classify--fit-prior --p-no-classify--fit-prior --p-feat-ext--alternate-sign --p-no-feat-ext--alternate-sign --p-feat-ext--analyzer --p-feat-ext--binary --p-no-feat-ext--binary --p-feat-ext--decode-error --p-feat-ext--encoding --p-feat-ext--input --p-feat-ext--lowercase --p-no-feat-ext--lowercase --p-feat-ext--n-features --p-feat-ext--ngram-range --p-feat-ext--norm --p-feat-ext--preprocessor --p-feat-ext--stop-words --p-feat-ext--strip-accents --p-feat-ext--token-pattern --p-feat-ext--tokenizer --p-verbose --p-no-verbose --o-classifier --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fit-classifier-sklearn)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reference-reads --i-reference-taxonomy --i-class-weight --p-classifier-specification --o-classifier --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                makeblastdb)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --o-database --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                vsearch-global)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query --i-reference-reads --p-maxaccepts --p-perc-identity --p-query-cov --p-strand --p-search-exact --p-no-search-exact --p-top-hits-only --p-no-top-hits-only --p-maxhits --p-maxrejects --p-output-no-hits --p-no-output-no-hits --p-weak-id --p-threads --o-search-results --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        feature-table)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "core-features filter-features filter-features-conditionally filter-samples filter-seqs group heatmap merge merge-seqs merge-taxa normalize presence-absence rarefy relative-frequency rename-ids split subsample-ids summarize summarize-plus tabulate-feature-frequencies tabulate-sample-frequencies tabulate-seqs transpose" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                core-features)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-min-fraction --p-max-fraction --p-steps --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-features)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-min-frequency --p-max-frequency --p-min-samples --p-max-samples --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --p-filter-empty-samples --p-no-filter-empty-samples --p-allow-empty-table --p-no-allow-empty-table --o-filtered-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-features-conditionally)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-abundance --p-prevalence --p-allow-empty-table --p-no-allow-empty-table --o-filtered-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-samples)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-min-frequency --p-max-frequency --p-min-features --p-max-features --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --p-filter-empty-features --p-no-filter-empty-features --p-allow-empty-table --p-no-allow-empty-table --o-filtered-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --i-table --m-metadata-file --p-where --p-exclude-ids --p-no-exclude-ids --o-filtered-data --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                group)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-axis --m-metadata-file --m-metadata-column --p-mode --o-grouped-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                heatmap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-sample-metadata-file --m-sample-metadata-column --m-feature-metadata-file --m-feature-metadata-column --p-normalize --p-no-normalize --p-title --p-metric --p-method --p-cluster --p-color-scheme --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-tables --p-overlap-method --o-merged-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --o-merged-data --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge-taxa)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --o-merged-data --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                normalize)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-gene-length --p-method --p-m-trim --p-a-trim --o-normalized-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                presence-absence)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-presence-absence-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                rarefy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-sampling-depth --p-with-replacement --p-no-with-replacement --p-random-seed --o-rarefied-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                relative-frequency)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-relative-frequency-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                rename-ids)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-axis --p-strict --p-no-strict --o-renamed-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                split)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-filter-empty-features --p-no-filter-empty-features --o-tables --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                subsample-ids)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --p-subsampling-depth --p-axis --p-random-seed --o-sampled-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                summarize)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-sample-metadata-file --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                summarize-plus)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --o-feature-frequencies --o-sample-frequencies --o-summary --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate-feature-frequencies)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-feature-frequencies --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate-sample-frequencies)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-sample-frequencies --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --i-taxonomy --m-metadata-file --p-merge-method --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                transpose)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --o-transposed-feature-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        fondue)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations --show-hidden-actions" -- $incomplete)"
              else
                echo "$(compgen -W "combine-seqs get-all get-ids-from-query get-metadata get-sequences merge-metadata scrape-collection" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                combine-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-seqs --p-on-duplicates --o-combined-seqs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-all)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-accession-ids --i-linked-doi --p-email --p-threads --p-retries --p-log-level --o-metadata --o-single-reads --o-paired-reads --o-failed-runs --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-ids-from-query)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-query --p-email --p-threads --p-log-level --o-ids --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-metadata)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-accession-ids --i-linked-doi --p-email --p-threads --p-log-level --o-metadata --o-failed-runs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-sequences)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-accession-ids --p-email --p-retries --p-threads --p-log-level --p-restricted-access --p-no-restricted-access --o-single-reads --o-paired-reads --o-failed-runs --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge-metadata)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-metadata --o-merged-metadata --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                scrape-collection)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-collection-name --p-on-no-dois --p-log-level --o-run-ids --o-study-ids --o-bioproject-ids --o-experiment-ids --o-sample-ids --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        fragment-insertion)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "classify-otus-experimental filter-features sepp" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                classify-otus-experimental)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-representative-sequences --i-tree --i-reference-taxonomy --o-classification --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-features)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-tree --o-filtered-table --o-removed-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                sepp)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-representative-sequences --i-reference-database --p-alignment-subset-size --p-placement-subset-size --p-threads --p-debug --p-no-debug --o-tree --o-placements --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        kmerizer)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "core-metrics seqs-to-kmers" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                core-metrics)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --p-sampling-depth --m-metadata-file --p-kmer-size --p-tfidf --p-no-tfidf --p-max-df --p-min-df --p-max-features --p-with-replacement --p-no-with-replacement --p-n-jobs --p-pc-dimensions --p-color-by --p-norm --o-rarefied-table --o-kmer-table --o-observed-features-vector --o-shannon-vector --o-jaccard-distance-matrix --o-bray-curtis-distance-matrix --o-jaccard-pcoa-results --o-bray-curtis-pcoa-results --o-scatterplot --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                seqs-to-kmers)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --p-kmer-size --p-tfidf --p-no-tfidf --p-max-df --p-min-df --p-max-features --p-norm --o-kmer-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        longitudinal)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "anova feature-volatility first-differences first-distances linear-mixed-effects maturity-index nmit pairwise-differences pairwise-distances plot-feature-volatility volatility" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                anova)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --p-formula --p-sstype --p-repeated-measures --p-no-repeated-measures --p-individual-id-column --p-rm-aggregate --p-no-rm-aggregate --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                feature-volatility)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-state-column --p-individual-id-column --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --p-importance-threshold --p-feature-count --o-filtered-table --o-feature-importance --o-volatility-plot --o-accuracy-results --o-sample-estimator --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                first-differences)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-state-column --p-individual-id-column --p-metric --p-replicate-handling --p-baseline --o-first-differences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                first-distances)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --p-state-column --p-individual-id-column --p-baseline --p-replicate-handling --o-first-distances --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                linear-mixed-effects)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-state-column --p-individual-id-column --p-metric --p-group-columns --p-random-effects --p-palette --p-lowess --p-no-lowess --p-ci --p-formula --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                maturity-index)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-state-column --p-group-by --p-control --p-individual-id-column --p-estimator --p-n-estimators --p-test-size --p-step --p-cv --p-random-state --p-n-jobs --p-parameter-tuning --p-no-parameter-tuning --p-optimize-feature-selection --p-no-optimize-feature-selection --p-stratify --p-no-stratify --p-missing-samples --p-feature-count --o-sample-estimator --o-feature-importance --o-predictions --o-model-summary --o-accuracy-results --o-maz-scores --o-clustermap --o-volatility-plots --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                nmit)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-individual-id-column --p-corr-method --p-dist-method --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                pairwise-differences)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-metric --p-state-column --p-state-1 --p-state-2 --p-individual-id-column --p-group-column --p-parametric --p-no-parametric --p-palette --p-replicate-handling --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                pairwise-distances)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --p-group-column --p-state-column --p-state-1 --p-state-2 --p-individual-id-column --p-parametric --p-no-parametric --p-palette --p-replicate-handling --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                plot-feature-volatility)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-importances --m-metadata-file --p-state-column --p-individual-id-column --p-default-group-column --p-yscale --p-importance-threshold --p-feature-count --p-missing-samples --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                volatility)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-state-column --p-individual-id-column --p-default-group-column --p-default-metric --p-yscale --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        metadata)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "distance-matrix merge shuffle-groups tabulate" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                distance-matrix)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --m-metadata-column --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata1-file --m-metadata2-file --o-merged-metadata --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                shuffle-groups)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --m-metadata-column --p-n-columns --p-md-column-name-prefix --p-md-column-values-prefix --p-encode-sample-size --p-no-encode-sample-size --o-shuffled-groups --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                tabulate)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-input-file --p-page-size --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        phylogeny)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "align-to-tree-mafft-fasttree align-to-tree-mafft-iqtree align-to-tree-mafft-raxml fasttree filter-table filter-tree iqtree iqtree-ultrafast-bootstrap midpoint-root raxml raxml-rapid-bootstrap robinson-foulds" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                align-to-tree-mafft-fasttree)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-n-threads --p-mask-max-gap-frequency --p-mask-min-conservation --p-parttree --p-no-parttree --p-large --p-no-large --o-alignment --o-masked-alignment --o-tree --o-rooted-tree --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                align-to-tree-mafft-iqtree)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-n-threads --p-mask-max-gap-frequency --p-mask-min-conservation --p-parttree --p-no-parttree --p-large --p-no-large --p-substitution-model --p-fast --p-no-fast --p-alrt --p-seed --p-stop-iter --p-perturb-nni-strength --o-alignment --o-masked-alignment --o-tree --o-rooted-tree --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                align-to-tree-mafft-raxml)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-n-threads --p-mask-max-gap-frequency --p-mask-min-conservation --p-parttree --p-no-parttree --p-large --p-no-large --p-substitution-model --p-seed --p-raxml-version --o-alignment --o-masked-alignment --o-tree --o-rooted-tree --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fasttree)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-n-threads --o-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-table)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-tree --o-filtered-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-tree)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-tree --i-table --m-metadata-file --p-where --o-filtered-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                iqtree)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-seed --p-n-cores --p-n-cores-max --p-n-runs --p-substitution-model --p-n-init-pars-trees --p-n-top-init-trees --p-n-best-retain-trees --p-n-iter --p-stop-iter --p-perturb-nni-strength --p-spr-radius --p-allnni --p-no-allnni --p-fast --p-no-fast --p-alrt --p-abayes --p-no-abayes --p-lbp --p-safe --p-no-safe --o-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                iqtree-ultrafast-bootstrap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-seed --p-n-cores --p-n-cores-max --p-n-runs --p-substitution-model --p-bootstrap-replicates --p-n-init-pars-trees --p-n-top-init-trees --p-n-best-retain-trees --p-stop-iter --p-perturb-nni-strength --p-spr-radius --p-n-max-ufboot-iter --p-n-ufboot-steps --p-min-cor-ufboot --p-ep-break-ufboot --p-allnni --p-no-allnni --p-alrt --p-abayes --p-no-abayes --p-lbp --p-bnni --p-no-bnni --p-safe --p-no-safe --o-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                midpoint-root)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-tree --o-rooted-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                raxml)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-seed --p-n-searches --p-n-threads --p-raxml-version --p-substitution-model --o-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                raxml-rapid-bootstrap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alignment --p-seed --p-rapid-bootstrap-seed --p-bootstrap-replicates --p-n-threads --p-raxml-version --p-substitution-model --o-tree --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                robinson-foulds)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-trees --p-labels --p-missing-tips --o-distance-matrix --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        quality-control)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "bowtie2-build decontam-identify decontam-identify-batches decontam-score-viz evaluate-composition evaluate-seqs evaluate-taxonomy exclude-seqs filter-reads" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                bowtie2-build)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-n-threads --o-database --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                decontam-identify)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-method --p-freq-concentration-column --p-prev-control-column --p-prev-control-indicator --o-decontam-scores --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                decontam-identify-batches)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-rep-seqs --m-metadata-file --p-split-column --p-method --p-filter-empty-features --p-no-filter-empty-features --p-freq-concentration-column --p-prev-control-column --p-prev-control-indicator --p-threshold --p-weighted --p-no-weighted --p-bin-size --o-batch-subset-tables --o-decontam-scores --o-score-histograms --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                decontam-score-viz)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-decontam-scores --i-table --i-rep-seqs --p-threshold --p-weighted --p-no-weighted --p-bin-size --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-composition)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-expected-features --i-observed-features --p-depth --p-palette --p-plot-tar --p-no-plot-tar --p-plot-tdr --p-no-plot-tdr --p-plot-r-value --p-no-plot-r-value --p-plot-r-squared --p-no-plot-r-squared --p-plot-bray-curtis --p-no-plot-bray-curtis --p-plot-jaccard --p-no-plot-jaccard --p-plot-observed-features --p-no-plot-observed-features --p-plot-observed-features-ratio --p-no-plot-observed-features-ratio --m-metadata-file --m-metadata-column --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query-sequences --i-reference-sequences --p-show-alignments --p-no-show-alignments --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-taxonomy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-expected-taxa --i-observed-taxa --i-feature-table --p-depth --p-palette --p-require-exp-ids --p-no-require-exp-ids --p-require-obs-ids --p-no-require-obs-ids --p-sample-id --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                exclude-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-query-sequences --i-reference-sequences --p-method --p-perc-identity --p-evalue --p-perc-query-aligned --p-threads --p-left-justify --o-sequence-hits --o-sequence-misses --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-reads)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-sequences --i-database --p-n-threads --p-mode --p-sensitivity --p-ref-gap-open-penalty --p-ref-gap-ext-penalty --p-exclude-seqs --p-no-exclude-seqs --o-filtered-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        quality-filter)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "q-score" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                q-score)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --p-min-quality --p-quality-window --p-min-length-fraction --p-max-ambiguous --p-num-processes --o-filtered-sequences --o-filter-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        rescript)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "cull-seqs degap-seqs dereplicate edit-taxonomy evaluate-classifications evaluate-cross-validate evaluate-fit-classifier evaluate-seqs evaluate-taxonomy extract-seq-segments filter-seqs-length filter-seqs-length-by-taxon filter-taxa get-bv-brc-genome-features get-bv-brc-genomes get-bv-brc-metadata get-eukaryome-data get-gtdb-data get-midori2-data get-ncbi-data get-ncbi-data-protein get-ncbi-genomes get-pr2-data get-silva-data get-unite-data merge-taxa orient-reads orient-seqs parse-silva-taxonomy reverse-transcribe subsample-fasta trim-alignment" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                cull-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-num-degenerates --p-homopolymer-length --p-n-jobs --o-clean-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                degap-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-aligned-sequences --p-min-length --o-degapped-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                dereplicate)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-taxa --p-mode --p-perc-identity --p-threads --p-rank-handles --p-derep-prefix --p-no-derep-prefix --o-dereplicated-sequences --o-dereplicated-taxa --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                edit-taxonomy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-taxonomy --m-replacement-map-file --m-replacement-map-column --p-search-strings --p-replacement-strings --p-use-regex --p-no-use-regex --o-edited-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-classifications)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-expected-taxonomies --i-observed-taxonomies --p-labels --o-evaluation --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-cross-validate)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-taxonomy --p-k --p-random-state --p-reads-per-batch --p-n-jobs --p-confidence --o-expected-taxonomy --o-observed-taxonomy --o-evaluation --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-fit-classifier)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-taxonomy --p-reads-per-batch --p-n-jobs --p-confidence --o-classifier --o-evaluation --o-observed-taxonomy --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-labels --p-kmer-lengths --p-subsample-kmers --p-palette --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                evaluate-taxonomy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-taxonomies --p-labels --p-rank-handle-regex --o-taxonomy-stats --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                extract-seq-segments)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-input-sequences --i-reference-segment-sequences --p-perc-identity --p-target-coverage --p-min-seq-len --p-max-seq-len --p-threads --o-extracted-sequence-segments --o-unmatched-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-seqs-length)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-global-min --p-global-max --p-threads --o-filtered-seqs --o-discarded-seqs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-seqs-length-by-taxon)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-taxonomy --p-labels --p-min-lens --p-max-lens --p-global-min --p-global-max --o-filtered-seqs --o-discarded-seqs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-taxa)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-taxonomy --m-ids-to-keep-file --p-include --p-exclude --o-filtered-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-bv-brc-genome-features)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-ids-metadata-file --m-ids-metadata-column --p-rql-query --p-data-field --p-ids --p-ranks --p-rank-propagation --p-no-rank-propagation --o-genes --o-proteins --o-taxonomy --o-loci --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-bv-brc-genomes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-ids-metadata-file --m-ids-metadata-column --p-rql-query --p-data-field --p-ids --p-ranks --p-rank-propagation --p-no-rank-propagation --o-genomes --o-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-bv-brc-metadata)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-ids-metadata-file --m-ids-metadata-column --p-data-type --p-rql-query --p-data-field --p-ids --o-metadata --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-eukaryome-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-rrna-gene --p-version --o-eukaryome-sequences --o-eukaryome-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-gtdb-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-version --p-domain --p-db-type --p-url-type --o-gtdb-taxonomy --o-gtdb-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-midori2-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-mito-gene --p-version --p-ref-seq-type --p-unspecified-species --p-no-unspecified-species --o-midori2-sequences --o-midori2-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-ncbi-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-query --m-accession-ids-file --p-ranks --p-rank-propagation --p-no-rank-propagation --p-logging-level --p-n-jobs --o-sequences --o-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-ncbi-data-protein)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-query --m-accession-ids-file --p-ranks --p-rank-propagation --p-no-rank-propagation --p-logging-level --p-n-jobs --o-sequences --o-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-ncbi-genomes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-taxa --p-assembly-source --p-assembly-levels --p-only-reference --p-no-only-reference --p-only-genomic --p-no-only-genomic --p-tax-exact-match --p-no-tax-exact-match --p-page-size --p-ranks --p-rank-propagation --p-no-rank-propagation --o-genome-assemblies --o-loci --o-proteins --o-taxonomies --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-pr2-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-version --p-ranks --o-pr2-sequences --o-pr2-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-silva-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-version --p-target --p-include-species-labels --p-no-include-species-labels --p-rank-propagation --p-no-rank-propagation --p-ranks --p-download-sequences --p-no-download-sequences --o-silva-sequences --o-silva-taxonomy --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                get-unite-data)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --p-version --p-taxon-group --p-cluster-id --p-singletons --p-no-singletons --o-taxonomy --o-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge-taxa)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --p-mode --p-rank-handle-regex --p-new-rank-handles --p-unclassified-label --o-merged-data --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                orient-reads)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-reference-sequences --p-dbmask --o-oriented-reads --o-unmatched-reads --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                orient-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-reference-sequences --p-dbmask --p-relabel --p-relabel-keep --p-no-relabel-keep --p-relabel-md5 --p-no-relabel-md5 --p-relabel-self --p-no-relabel-self --p-relabel-sha1 --p-no-relabel-sha1 --p-sizein --p-no-sizein --p-sizeout --p-no-sizeout --o-oriented-seqs --o-unmatched-seqs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                parse-silva-taxonomy)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-taxonomy-tree --i-taxonomy-map --i-taxonomy-ranks --p-rank-propagation --p-no-rank-propagation --p-ranks --p-include-species-labels --p-no-include-species-labels --o-taxonomy --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                reverse-transcribe)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-rna-sequences --o-dna-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                subsample-fasta)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-subsample-size --p-random-seed --o-sample-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                trim-alignment)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-aligned-sequences --p-primer-fwd --p-primer-rev --p-position-start --p-position-end --p-keep-primer-location --p-no-keep-primer-location --p-n-threads --o-trimmed-sequences --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        sample-classifier)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "classify-samples classify-samples-from-dist classify-samples-ncv confusion-matrix fit-classifier fit-regressor heatmap metatable predict-classification predict-regression regress-samples regress-samples-ncv scatterplot split-table summarize" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                classify-samples)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-test-size --p-step --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-optimize-feature-selection --p-no-optimize-feature-selection --p-parameter-tuning --p-no-parameter-tuning --p-palette --p-missing-samples --o-sample-estimator --o-feature-importance --o-predictions --o-model-summary --o-accuracy-results --o-probabilities --o-heatmap --o-training-targets --o-test-targets --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-samples-from-dist)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distance-matrix --m-metadata-file --m-metadata-column --p-k --p-cv --p-random-state --p-n-jobs --p-palette --o-predictions --o-accuracy-results --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                classify-samples-ncv)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --o-predictions --o-feature-importance --o-probabilities --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                confusion-matrix)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-predictions --i-probabilities --m-truth-file --m-truth-column --p-missing-samples --p-vmin --p-vmax --p-palette --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fit-classifier)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-step --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-optimize-feature-selection --p-no-optimize-feature-selection --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --o-sample-estimator --o-feature-importance --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fit-regressor)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-step --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-optimize-feature-selection --p-no-optimize-feature-selection --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --o-sample-estimator --o-feature-importance --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                heatmap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-importance --m-sample-metadata-file --m-sample-metadata-column --m-feature-metadata-file --m-feature-metadata-column --p-feature-count --p-importance-threshold --p-group-samples --p-no-group-samples --p-normalize --p-no-normalize --p-missing-samples --p-metric --p-method --p-cluster --p-color-scheme --o-heatmap --o-filtered-table --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                metatable)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --p-missing-samples --p-missing-values --p-drop-all-unique --p-no-drop-all-unique --o-converted-table --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                predict-classification)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-sample-estimator --p-n-jobs --o-predictions --o-probabilities --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                predict-regression)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-sample-estimator --p-n-jobs --o-predictions --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                regress-samples)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-test-size --p-step --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-optimize-feature-selection --p-no-optimize-feature-selection --p-stratify --p-no-stratify --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --o-sample-estimator --o-feature-importance --o-predictions --o-model-summary --o-accuracy-results --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                regress-samples-ncv)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-cv --p-random-state --p-n-jobs --p-n-estimators --p-estimator --p-stratify --p-no-stratify --p-parameter-tuning --p-no-parameter-tuning --p-missing-samples --o-predictions --o-feature-importance --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                scatterplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-predictions --m-truth-file --m-truth-column --p-missing-samples --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                split-table)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --m-metadata-file --m-metadata-column --p-test-size --p-random-state --p-stratify --p-no-stratify --p-missing-samples --o-training-table --o-test-table --o-training-targets --o-test-targets --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                summarize)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sample-estimator --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        stats)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "alpha-group-significance collate-stats facet-across facet-within mann-whitney-u mann-whitney-u-facet plot-rainclouds prep-alpha-distribution wilcoxon-srt wilcoxon-srt-facet" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                alpha-group-significance)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alpha-diversity --m-metadata-file --p-columns --p-subject --p-timepoint --o-distribution --o-stats --o-raincloud --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-stats)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-tables --o-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                facet-across)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --o-distributions --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                facet-within)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --o-distributions --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                mann-whitney-u)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --i-against-each --p-compare --p-reference-group --p-alternative --p-p-val-approx --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                mann-whitney-u-facet)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --p-facet --o-stats --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                plot-rainclouds)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-data --i-stats --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                prep-alpha-distribution)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-alpha-diversity --m-metadata-file --p-columns --p-subject --p-timepoint --o-distribution --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                wilcoxon-srt)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --p-compare --p-baseline-group --p-alternative --p-p-val-approx --p-ignore-empty-comparator --p-no-ignore-empty-comparator --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                wilcoxon-srt-facet)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-distribution --p-ignore-empty-comparator --p-no-ignore-empty-comparator --o-stats --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        taxa)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "barplot barplot2 collapse filter-seqs filter-table" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                barplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-taxonomy --m-metadata-file --p-level-delimiter --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                barplot2)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-taxonomy --m-metadata-file --p-level-delimiter --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collapse)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-taxonomy --p-level --o-collapsed-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-seqs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-taxonomy --p-include --p-exclude --p-query-delimiter --p-mode --o-filtered-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                filter-table)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-table --i-taxonomy --p-include --p-exclude --p-query-delimiter --p-mode --o-filtered-table --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        types)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "collate-contigs collate-feature-data-mags collate-genes collate-genomes collate-kraken2-outputs collate-kraken2-reports collate-loci collate-ortholog-annotations collate-orthologs collate-proteins collate-sample-data-mags partition-contigs partition-feature-data-mags partition-kraken2-outputs partition-kraken2-reports partition-orthologs partition-sample-data-mags partition-samples-paired partition-samples-single" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                collate-contigs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-contigs --o-collated-contigs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-feature-data-mags)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-mags --o-collated-mags --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-genes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-genes --o-collated-genes --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-genomes)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-genomes --p-on-duplicates --o-collated-genomes --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-kraken2-outputs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-kraken2-outputs --o-collated-kraken2-outputs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-kraken2-reports)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-kraken2-reports --o-collated-kraken2-reports --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-loci)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-loci --o-collated-loci --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-ortholog-annotations)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-ortholog-annotations --o-collated-annotations --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-orthologs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-orthologs --o-collated-orthologs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-proteins)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-proteins --o-collated-proteins --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                collate-sample-data-mags)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-mags --o-collated-mags --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-contigs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-contigs --p-num-partitions --o-partitioned-contigs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-feature-data-mags)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-mags --p-num-partitions --o-partitioned-mags --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-kraken2-outputs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-outputs --p-num-partitions --o-partitioned-outputs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-kraken2-reports)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-reports --p-num-partitions --o-partitioned-reports --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-orthologs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-orthologs --p-num-partitions --o-partitioned-orthologs --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-sample-data-mags)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-mags --p-num-partitions --o-partitioned-mags --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-samples-paired)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --p-num-partitions --o-partitioned-demux --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                partition-samples-single)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demux --p-num-partitions --o-partitioned-demux --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        vizard)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "boxplot heatmap lineplot scatterplot-2d" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                boxplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --p-distribution-measure --p-group-by --p-whisker-range --p-box-orientation --p-title --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                heatmap)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --p-x-measure --p-y-measure --p-gradient-measure --p-title --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                lineplot)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --p-x-measure --p-y-measure --p-replicate-method --p-group-by --p-title --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                scatterplot-2d)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --m-metadata-file --p-x-measure --p-y-measure --p-color-by --p-title --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

        vsearch)
          curpos=${nextpos}
          while :
          do
            nextpos=$((curpos + 1))
            nextword="${COMP_WORDS[nextpos]}"
            if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
              if [[ ${incomplete} == -* ]] ; then
                echo "$(compgen -W "--help --version --example-data --citations" -- $incomplete)"
              else
                echo "$(compgen -W "cluster-features-closed-reference cluster-features-de-novo cluster-features-open-reference dereplicate-sequences fastq-stats merge-pairs uchime-denovo uchime-ref" -- $incomplete)"
              fi
              return 0
            else
              case "${nextword}" in
                cluster-features-closed-reference)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --i-reference-sequences --p-perc-identity --p-strand --p-threads --o-clustered-table --o-clustered-sequences --o-unmatched-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cluster-features-de-novo)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --p-perc-identity --p-strand --p-threads --o-clustered-table --o-clustered-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                cluster-features-open-reference)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --i-reference-sequences --p-perc-identity --p-strand --p-threads --o-clustered-table --o-clustered-sequences --o-new-reference-sequences --output-dir --verbose --quiet --recycle-pool --no-recycle --parallel --parallel-config --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                dereplicate-sequences)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-derep-prefix --p-no-derep-prefix --p-min-seq-length --p-min-unique-size --o-dereplicated-table --o-dereplicated-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                fastq-stats)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --p-threads --o-visualization --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                merge-pairs)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-demultiplexed-seqs --p-truncqual --p-minlen --p-maxns --p-allowmergestagger --p-no-allowmergestagger --p-minovlen --p-maxdiffs --p-minmergelen --p-maxmergelen --p-maxee --p-threads --p-qmin --p-qminout --p-qmax --p-qmaxout --o-merged-sequences --o-unmerged-sequences --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                uchime-denovo)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --p-method --p-dn --p-mindiffs --p-mindiv --p-minh --p-xn --o-chimeras --o-nonchimeras --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

                uchime-ref)
                  curpos=${nextpos}
                  while :
                  do
                    nextpos=$((curpos + 1))
                    nextword="${COMP_WORDS[nextpos]}"
                    if [[ ${nextpos} -eq ${COMP_CWORD} ]] ; then
                      if [[ ${incomplete} == -* ]] ; then
                        echo "$(compgen -W "--help --i-sequences --i-table --i-reference-sequences --p-dn --p-mindiffs --p-mindiv --p-minh --p-xn --p-threads --o-chimeras --o-nonchimeras --o-stats --output-dir --verbose --quiet --example-data --citations --use-cache" -- $incomplete)"
                      else
                        echo "$(compgen -W "" -- $incomplete)"
                      fi
                      return 0
                    else
                      case "${nextword}" in

                      esac
                      curpos=${nextpos}
                    fi
                  done
                  ;;

              esac
              curpos=${nextpos}
            fi
          done
          ;;

      esac
      curpos=${nextpos}
    fi
  done

  return 0
}

_qiime_completion
