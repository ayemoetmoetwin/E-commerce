import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constants.dart';
import '../utils/colors.dart';

class SearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;

  const SearchBar({
    super.key,
    this.hintText = AppStrings.searchHint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.inputFormatters,
  });

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final isSearching = _controller.text.isNotEmpty;
    if (isSearching != _isSearching) {
      setState(() {
        _isSearching = isSearching;
      });
    }

    widget.onChanged?.call(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onClear?.call();
  }

  void _onSubmitted(String value) {
    widget.onSubmitted?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
        boxShadow: [
          BoxShadow(
            color: AppColors.iconGrey.withValues(alpha: 0.5),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        enabled: widget.enabled,
        inputFormatters: widget.inputFormatters,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.iconGrey),
          prefixIcon: Icon(Icons.search, color: AppColors.grey_500),
          suffixIcon: _isSearching
              ? IconButton(
                  onPressed: _onClear,
                  icon: Icon(Icons.clear, color: AppColors.iconGrey),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
            vertical: AppConstants.defaultPadding,
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: _onSubmitted,
        textInputAction: TextInputAction.search,
      ),
    );
  }
}

class AnimatedSearchBar extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Duration animationDuration;

  const AnimatedSearchBar({
    super.key,
    this.hintText = AppStrings.searchHint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.animationDuration = AppConstants.mediumAnimation,
  });

  @override
  State<AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus && !_isExpanded) {
      setState(() {
        _isExpanded = true;
      });
      _animationController.forward();
    } else if (!_focusNode.hasFocus &&
        _isExpanded &&
        _controller.text.isEmpty) {
      setState(() {
        _isExpanded = false;
      });
      _animationController.reverse();
    }
  }

  void _onClear() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          height: 48,
          child: Row(
            children: [
              Expanded(
                flex: _isExpanded ? 1 : 0,
                child: _isExpanded
                    ? SearchBar(
                        hintText: widget.hintText,
                        onChanged: widget.onChanged,
                        onSubmitted: widget.onSubmitted,
                        onClear: _onClear,
                        enabled: widget.enabled,
                        controller: _controller,
                        focusNode: _focusNode,
                      )
                    : const SizedBox.shrink(),
              ),
              if (!_isExpanded)
                IconButton(
                  onPressed: () {
                    _focusNode.requestFocus();
                  },
                  icon: const Icon(Icons.search),
                ),
            ],
          ),
        );
      },
    );
  }
}

class SearchBarWithFilters extends StatefulWidget {
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final VoidCallback? onFilterTap;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final int? filterCount;

  const SearchBarWithFilters({
    super.key,
    this.hintText = AppStrings.searchHint,
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.onFilterTap,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.filterCount,
  });

  @override
  State<SearchBarWithFilters> createState() => _SearchBarWithFiltersState();
}

class _SearchBarWithFiltersState extends State<SearchBarWithFilters> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();

    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onTextChanged() {
    final isSearching = _controller.text.isNotEmpty;
    if (isSearching != _isSearching) {
      setState(() {
        _isSearching = isSearching;
      });
    }

    widget.onChanged?.call(_controller.text);
  }

  void _onClear() {
    _controller.clear();
    _focusNode.unfocus();
    widget.onClear?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SearchBar(
            hintText: widget.hintText,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            onClear: _onClear,
            enabled: widget.enabled,
            controller: _controller,
            focusNode: _focusNode,
          ),
        ),
        const SizedBox(width: AppConstants.smallPadding),
        if (widget.onFilterTap != null)
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(
                AppConstants.defaultBorderRadius,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.iconGrey.withValues(alpha: 0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: widget.onFilterTap,
              icon: Stack(
                children: [
                  const Icon(Icons.filter_list),
                  if (widget.filterCount != null && widget.filterCount! > 0)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.favorite,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          widget.filterCount.toString(),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
