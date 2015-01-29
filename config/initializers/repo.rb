# NOTE: I was having wierd issues with rails refeshing classes in dev and
# loosing these configs, so I copied them to the RepoStore class. If you're
# changing them here and it's not working, check there.
RepoStore.repo.register :ar, ActiveRecordAdapter.new
RepoStore.repo.use :ar
