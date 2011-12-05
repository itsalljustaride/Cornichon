class SysParam
  def self.all
    # create a cached hash
    @cache ||= Systemparameter.all.inject({}) do |hsh, c_config|
      hsh[c_config.param.to_sym] = c_config.paramvalue
      hsh
    end
  end 

  def self.get(key)
    self.all[key.to_sym]
  end

  def self.[](key)
    self.all[key.to_sym]
  end
end