

# Class ContextFeatureMapping in module Application
#
# authors Duhoux Benoît and Sarkozi David
# Version 2016

module Application

  module ContextFeatureMapping
  
    attr_reader :context_to_features, :feature_to_contexts
    
    def initialize
      @context_to_features = {}
      @feature_to_contexts = {}
    end
    
    def add_feature_mapping(feature, contexts)
      @feature_to_contexts[feature] = contexts
      contexts.each {
        |context|
        unless @context_to_features[context].include?(feature)
          @context_to_features[context] << feature
        end
      }
    end
    
    def add_context_mapping(context, features)
      @context_to_features[context] = features
      features.each {
        |feature|
        unless @feature_to_contexts[feature].include?(context)
          @feature_to_contexts[feature] << context
        end
      }
    end
    
    def remove_feature_mapping(feature)
      @feature_to_contexts.delete(feature)
      @context_to_features.each {
        |features|
        features.delete(feature)
      }
    end
    
    def remove_context_mapping(context)
      @context_to_features.delete(context)
      @feature_to_contexts.each {
        |contexts|
        contexts.delete(context)
      }
    end
    
    def get_feature_mapping(feature)
      @feature_to_contexts[feature]
    end
    
    def get_context_mapping(context)
      @context_to_features[context]
    end
    
    def change_feature_selection(activating_contexts, deactivating_contexts, active_contexts)
      {
        :toSelect => selected_features(activating_contexts, active_contexts),
        :toUnselect => unselected_features(deactivating_contexts, active_contexts)
      }
    end
    
    private
    
    # Upon activating contexts, select from the concerned features
    # those which will have all their core contexts active at the end
    # of the activation process
    def selected_features(activating_contexts, active_contexts)
      concerned = concerned_features(activating_contexts)
      selected = []
      # activated_contexts = activating_contexts + active_contexts
      
      concerned.each {
        |feature|
        concerned_contexts = @feature_to_contexts[feature]
        # TODO remove already active features from active contexts
        # then create relevant_contexts and include feature in
        # selected the number of times its mapping appears in
        # relevant_contexts
      }
    end
    
    # Upon deactivating contexts, unselect concerned features
    # having at least one of their core contexts deactivated
    def unselected_features(deactivating_contexts, active_contexts)
      concerned = concerned_features(deactivating_contexts)
      unselected = []
      
      concerned.each {
        |feature|
        concerned_contexts = @feature_to_contexts[feature]
        # TODO Guess feature selection counts before and after
        # deactivation ?
      }
    end
    
    def concerned_features(contexts)
      concerned = []
      contexts.each {
        |context|
        concerned.concat(@context_to_features[context.name])
      }
      concerned
    end
    
    def
    end
    
  end

end