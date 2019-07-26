module PageObjects
end

Dir[Rails.root.join('spec/ui_lib/page_objects/*.rb')].sort.each { |f| require f }
