class BaseRepo
  extend RepoStore::Delegation

  UnknownIdError = Tnt.boom "Unknown id."
end
