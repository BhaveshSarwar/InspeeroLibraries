Pod::Spec.new do |mdc|
  mdc.name         = "InspeeroLibs"
  mdc.version      = "0.1.0"
  mdc.authors      = "Inspeero Technologies."
  mdc.summary      = "A collection of stand-alone production-ready libraries focused on reusbility details."
  mdc.homepage     = "https://git2.inspeero.com/bsarwar/InspeeroLibraries"
  mdc.license      = "MIT"
  mdc.source       = { :git => "https://git2.inspeero.com/bsarwar/InspeeroLibraries.git", :tag => mdc.version , :branch=>"develop" }
  mdc.platform     = :ios
  mdc.requires_arc = true
  mdc.ios.deployment_target = '10.0'
  mdc.swift_version  	 = "4.2"

  # InAppPurchase

  mdc.subspec "InAppPurchase" do |component|
    component.ios.deployment_target = '10.0'
    component.source_files = "Components/#{component.base_name}/Source/*"
  end
end